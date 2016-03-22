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

def curs():
    connection.ping(True)
    return connection.cursos()


            ########
            ##MAIN##
            ########

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

            ########
            ##USER##
            ########

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
    except:
        return jsonify(code=4, response='error')

@app.route('/db/api/user/details/', methods=['GET'])
def user_details():
	try:
		user = request.args['user']
		return jsonify(code=0, response=get_user_info(user, connection))
	except KeyError:
		return jsonify(code=2, response='invalid json')
	except IntegrityError, e:
		if e[0] == 1062:
			return jsonify(code=0, response=get_user_info(user, connection))
		elif e[0] == 1452:
			return jsonify(code=1, response='user not found')
	except:
		return jsonify(code=4, response='error')

@app.route('/db/api/user/follow/', methods=['POST'])
def user_follow():
    cursor, conn = connection()
    try:
        data = request.get_json()
        follower = data['follower']
        followee = data['followee']
        cursor.execute("INSERT INTO follows (follower, followee) VALUES (%s, %s)", (follower, followee))
        conn.commit()
        cursos.close()
        return jsonify(code=0,
                        response=get_user_info(follower, conn))
    except KeyError:
        return jsonify(code=2, response='invalid json')
    except IntegrityError, e:
        if e[0] == 1062:
            return jsonify(code=0, response=get_user_info(follower,conn))
        elif e[0] == 1452:
            return jsonify(code=1, response='user not found')
    except:
        return jsonify(code=4, response='error')

@app.route('/db/api/user/unfollow/', methods=['POST'])
def user_unfollow():
	cursor = curs()
	try:
		data = request.get_json()
		follower = data['follower']
		followee = data['followee']
		cursor.execute("delete from follows where followee = %s and follower = %s",(followee, follower))
		connection.commit()
		cursor.close()
		return jsonify(code=0,
				   response=get_user_info(follower, connection))
	except KeyError:
		return jsonify(code=2, response='invalid json')
	except IntegrityError, e:
		if e[0] == 1062:
			return jsonify(code=0, response=get_user_info(follower, connection))
		elif e[0] == 1452:
			return jsonify(code=1, response='user not found')
	except:
		return jsonify(code=4, response='opps')

@app.route('/db/api/user/listFollowers/', methods=['GET'])
def user_listFollowers():
	try:
		cursor = curs()
		user = request.args['user']
		limit = request.args.get('limit', '')
		order = request.args.get('order', 'desc')
		since_id = request.args.get('since_id', 0)
		cursor.execute("select max(id) from users")
		max_id = cursor.fetchone()[0]
		query = """select follows.follower from follows join users on follows.follower = users.email and
		follows.followee = '{}'
		where users.id between {} and {}
		order by follows.follower {} """.format(user, since_id, max_id, order)
		query += "limit {}".format(limit) if limit != '' else ''
		cursor.execute(query)
		a = []
		for i in tuple(t[0] for t in cursor.fetchall()):
			a.append(get_user_info(i, connection))
		cursor.close()
		return jsonify(code=0, response=a)
	except KeyError:
		return jsonify(code=2, response='invalid json')
	except DoesNotExist:
		return jsonify(code=1, response='does not exist')
	except IntegrityError, e:
		return jsonify(code=1, response='something not found')
	except:
		return jsonify(code=4, response='opps')

@app.route('/db/api/user/listFollowing/', methods=['GET'])
def user_listFollowing():
	cursor = curs()
	try:
		user = request.args['user']
		limit = request.args.get('limit', '')
		order = request.args.get('order', 'desc')
		since_id = request.args.get('since_id', 0)
		cursor.execute("select max(id) from users")
		max_id = cursor.fetchone()[0]
		query = """select follows.followee from follows join users on follows.followee = users.email and
		follows.follower = '{}'
		where users.id between {} and {}
		order by follows.followee {} """.format(user, since_id, max_id, order)
		query += "limit {}".format(limit) if limit != '' else ''
		cursor.execute(query)
		a = []
		for i in tuple(t[0] for t in cursor.fetchall()):
			a.append(get_user_info(i, connection))
		cursor.close()
		return jsonify(code=0, response=a)
	except KeyError:
		return jsonify(code=2, response='invalid json')
	except DoesNotExist:
		return jsonify(code=1, response='does not exist')
	except IntegrityError, e:
		return jsonify(code=1, response='something not found')
	except:
		return jsonify(code=4, response='opps')

@app.route('/db/api/user/updateProfile/', methods=['POST'])
def user_update():
	cursor = curs()
	try:
		data = request.get_json()
		name = data['name']
		user = data['user']
		about = data['about']
		cursor.execute("update users set name = %s, about = %s where email = %s",(name, about, user))
		connection.commit()
		cursor.close()
		return jsonify(code=0,
				   response=get_user_info(user, connection))
	except KeyError:
		return jsonify(code=2, response='invalid json')
	except IntegrityError:
		return jsonify(code=1, response='user not found')
	except:
		return jsonify(code=4, response='opps')

@app.route('/db/api/user/listPosts/', methods=['GET'])
def user_listPosts():
	cursor = curs()
	try:
		user = request.args['user']
		limit = request.args.get('limit', '')
		order = request.args.get('order', 'desc')
		since_date = request.args.get('since', "1970-01-01 00:00:01")
		cursor.execute("select max(createDate) from posts")
		max_date = cursor.fetchone()[0]

		query = """select id from posts where userEmail = '{}' and
				createDate between '{}' and '{}' order by createDate {} """.format(user, since_date, max_date, order)

		query += "limit {}".format(limit) if limit != '' else ''
		cursor.execute(query)

		a = []
		for i in tuple(t[0] for t in cursor.fetchall()):
			a.append(get_post_info(i, connection))
		cursor.close()
		return jsonify(code=0, response=a)
	except KeyError:
		return jsonify(code=2, response='invalid json')
	except DoesNotExist:
		return jsonify(code=1, response='does not exist')
	except IntegrityError, e:
		return jsonify(code=1, response='something not found')
	except:
		return jsonify(code=4, response='opps')


def get_user_info(user_email, connection):
	cursor, conn = connection()
	if cursor.execute("select * from users where email = '{}'".format(user_email)) == 0:
		raise DoesNotExist
	user = cursor.fetchone()
	cursor.execute("select followee from follows where follower = '{}'".format(user[3]))
	follower_followee = cursor.fetchall()
	cursor.execute("select follower from follows where followee = '{}'".format(user[3]))
	followee_follower = cursor.fetchall()
	cursor.execute("select thread from subscribes where user = '{}'".format(user[3]))
	subs = cursor.fetchall()
	conn.close()
	return {'id':user[0],
			'name': user[1],
			'username': user[2],
			'email': user[3],
			'about':user[4],
			'isAnonymous':bool(user[5]),
			'following': list(t[0] for t in follower_followee),
			'followers': list(t[0] for t in followee_follower),
			'subscriptions': list(t[0] for t in subs)}

class DoesNotExist(Exception):
	pass

@app.route('/')
def test():
    return 'hello'

if __name__ == '__main__':
    app.run(debug=True)
