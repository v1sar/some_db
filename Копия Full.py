from flask import Flask, request, jsonify
from flask.ext.mysql import MySQL
import MySQLdb
from exceptions import KeyError
from _mysql_exceptions import IntegrityError


app = Flask(__name__)

def connection():
    conn = MySQLdb.connect(host='localhost',
                           user='root',
                           passwd='1',
                           db='db_api')
    c = conn.cursor()
    return c, conn

@app.route('/db/api/clear/', methods=['POST'])
def clear():
    try:
        cursor, conn = connection()
        cursor.execute("""delete from users""");
        conn.commit()
        conn.close()
        return jsonify(code=0, response="OK")
    except:
        return jsonify(code=4, response="error")

@app.route('/db/api/user/create/', methods=['POST'])
def user_create():
    try:
        cursor, conn = connection()
        data = request.get_json()
        name = data['name']
        username = data['username']
        email = data['email']
        about = data['about']
        isAnonymous = data.get('isAnonymous', False)
        isAnonymous = isAnonymous.lower()
        cursor.execute("""INSERT INTO users (name, username, email, about, isAnonymous)
        VALUES (%s, %s, %s, %s, %s)""",(name, username, email, about, isAnonymous))
        conn.commit()
        conn.close()
        return jsonify(code=0,
                    response={"id": cursor.lastrowid,
                              "name":name,
                              "username":username,
                              "email":email,
                              "isAnonymous":bool(isAnonymous),
                              "about":about
                              })
    except KeyError:
        return jsonify(code=2, response='invalid json')
    except IntegrityError:
        return jsonify(code=5, response='user already exists')

@app.route('/')
def test():
    return 'hello'

if __name__ == '__main__':
    app.run(debug=True)
