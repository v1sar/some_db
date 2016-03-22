from flask import Flask, request, jsonify
from flask.ext.mysql import MySQL
import MySQLdb
from exceptions import KeyError
from _mysql_exceptions import IntegrityError


#mysql = MySQL()
app = Flask(__name__)
#app.config['MYSQL_DATABASE_USER'] = 'root'
#app.config['MYSQL_DATABASE_PASSWORD'] = '1'
#app.config['MYSQL_DATABASE_DB'] = 'db_api'
#app.config['MYSQL_DATABASE_HOST'] = 'localhost'
#mysql.init_app(app)
#connection = mysql.connect()

def connection():
    conn = MySQLdb.connect(host="localhost",
                           user="root",
                           passwd="1",
                           db="db_api")
    c = conn.cursor()

    return c, conn


def curs():
	connection.ping(True)
	return connection.cursor()

        #########
        #GENERAL#
        #########

@app.route('/db/api/clear/', methods=['POST'])
def clear():
	try:
		cursor, conn = connection()
		cursor.execute("""delete from users""");
		conn.commit()
		conn.close()
		return jsonify(code=0, response="OK")
	except:
		return jsonify(code=4, response='opps')

@app.route("/db/api/status/", methods=['GET'])
def status():
	try:
		cursor, conn = connection()
		cursor.execute("select count(*) from users")
		count_users = cursor.fetchone()[0]
		cursor.execute("select count(*) from forums")
		count_forums = cursor.fetchone()[0]
		cursor.execute("select count(*) from threads")
		count_threads = cursor.fetchone()[0]
		cursor.execute("select count(*) from posts")
		count_posts = cursor.fetchone()[0]
		return jsonify(code=0, response={"user":count_users,
										"forum":count_forums,
										"thread": count_threads,
										"posts": count_posts})
	except:
		return jsonify(code=4, response='opps')
        ###############
        #USERS METHODS#
        ###############
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
		cursor.execute("""insert into users (name, username, email, about, isAnonymous)
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
		return jsonify(code=5,response='user alredy exist')


        #######
        #OTHER#
        #######


@app.route('/')
def hello_world():
    return 'Hello World!'

if __name__ == '__main__':
    app.run(debug=True)
