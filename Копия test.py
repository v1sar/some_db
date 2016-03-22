from __future__ import print_function # In python 2.7
import sys
from flask import Flask, request, jsonify
from flaskext.mysql import MySQL
import MySQLdb
from exceptions import KeyError
from _mysql_exceptions import IntegrityError



mysql = MySQL()
app = Flask(__name__)
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = '1'
app.config['MYSQL_DATABASE_DB'] = 'db_api'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
mysql.init_app(app)
connection = mysql.connect()

def curs():
	connection.ping(True)
	return connection.cursor()

        #########
        #GENERAL#
        #########

@app.route('/db/api/clear/', methods=['POST'])
def clear():
	try:
		cursor = curs()
		cursor.execute("""delete from users""");
		connection.commit()
		cursor.close()
		return jsonify(code=0, response="OK")
	except:
		return jsonify(code=4, response='opps')

@app.route("/db/api/status/", methods=['GET'])
def status():
	try:
		cursor = curs()
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
		cursor = curs()
		data = request.get_json()
		name = data['name']
		username = data['username']
		email = data['email']
		about = data['about']
		isAnonymous = data.get('isAnonymous', False)
		cursor.execute("""INSERT INTO users (name,username,email,about,isAnonymous)
		VALUES ('{}','{}','{}','{}','{}') """.format(name, username, email, about, isAnonymous))
		connection.commit()
		cursor.close()
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
	except:
		return jsonify(code=4, response='opps')


@app.route('/db/api/user/follow/', methods=["POST"])
def user_follow():
	cursor = curs()
	try:
		data = request.get_json()
		follower = data['follower']
		followee = data['followee']
		cursor.execute("insert into follows (follower, followee) VALUES (%s, %s)",(follower,followee))
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

        #######
        #OTHER#
        #######
class DoesNotExist(Exception):
	pass

def get_user_info(user_email, connection):
	cursor = connection.cursor()
	if cursor.execute("select * from users where email = '{}'".format(user_email)) == 0:
		raise DoesNotExist
	user = cursor.fetchone()
	cursor.execute("select followee from follows where follower = '{}'".format(user[3]))
	follower_followee = cursor.fetchall()
	cursor.execute("select follower from follows where followee = '{}'".format(user[3]))
	followee_follower = cursor.fetchall()
	cursor.execute("select thread from subscribes where userEmail = '{}'".format(user[3]))
	subs = cursor.fetchall()
	cursor.close()
	return {'id':user[0],
			'name': user[1],
			'username': user[2],
			'email': user[3],
			'about':user[4],
			'isAnonymous':bool(user[5]),
			'following': list(t[0] for t in follower_followee),
			'followers': list(t[0] for t in followee_follower),
			'subscriptions': list(t[0] for t in subs)}

def get_forum_info(forum_sname, connection, related=[]):
	cursor = connection.cursor()
	if cursor.execute("select * from forums where shortname = '{}'".format(forum_sname)) == 0:
		raise DoesNotExist
	forum = cursor.fetchone()
	cursor.close()
	return {'id': forum[0],
			'name': forum[1],
			'short_name': forum[2],
			'user': forum[4] if 'user' not in related else get_user_info(forum[4], connection)}

def get_thread_info(thread_id, connection, related=[]):
	cursor = connection.cursor()
	if cursor.execute("select * from threads where id = {}".format(thread_id)) == 0:
		raise DoesNotExist
	thread = cursor.fetchone()
	cursor.close()
	return { "date": thread[1].strftime("%Y-%m-%d %H:%M:%S"),
		     "dislikes": thread[10],
		     "forum": thread[2] if 'forum' not in related else get_forum_info(thread[2], connection),
		     "id": thread[0],
		     "isClosed": bool(thread[3]),
		     "isDeleted": bool(thread[4]),
		     "likes":thread[9],
		     "message": thread[5],
		     "points": thread[9]-thread[10],
		     "posts":thread[11],# if not bool(thread[4]) else 0,
		     "slug": thread[6],
		     "title": thread[7],
		     "user": thread[8] if 'user' not in related else get_user_info(thread[8], connection)
	}

def get_post_info(post_id, connection, related=[]):
	cursor = connection.cursor()
	if cursor.execute("select * from posts where id = {}".format(post_id)) == 0:
		raise DoesNotExist
	post = cursor.fetchone()
	cursor.close()
	return { "date": post[1].strftime("%Y-%m-%d %H:%M:%S"),
        "dislikes": post[13],
        "forum": post[2] if 'forum' not in related else get_forum_info(post[2], connection),
        "id": post[0],
        "isApproved": bool(post[4]),
        "isDeleted": bool(post[5]),
        "isEdited": bool(post[6]),
        "isHighlighted": bool(post[3]),
        "isSpam": bool(post[7]),
        "likes": post[12],
        "message": post[8],
        "parent": post[9],
        "points": post[12]-post[13],
        "thread": post[10] if 'thread' not in related else get_thread_info(post[10],connection),
        "user": post[11] if 'user' not in related else get_user_info(post[11], connection)
    }


@app.route('/')
def hello_world():
    return 'Hello World!'

if __name__ == '__main__':
    app.run(debug=True)
