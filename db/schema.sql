DROP DATABASE IF EXISTS forum;
CREATE DATABASE forum;
\c forum

CREATE TABLE members (
	id SERIAL PRIMARY KEY,
	name VARCHAR NOT NULL,
	username VARCHAR NOT NULL,
	password VARCHAR NOT NULL,
	email VARCHAR NOT NULL,
	join_date TIMESTAMP NOT NULL,
	img_url VARCHAR DEFAULT 'http://i.kinja-img.com/gawker-media/image/upload/s--fFAX6P5D--/cqqxy9jeimvz4hvhrayx.jpg',
	location VARCHAR,
	type VARCHAR NOT NULL DEFAULT 'Newbie' 
);

CREATE TABLE topics (
	id SERIAL PRIMARY KEY,
	title VARCHAR NOT NULL,
	member_id INTEGER NOT NULL REFERENCES members(id),
	created_at TIMESTAMP NOT NULL,
	ranking INTEGER DEFAULT 0
);

CREATE TABLE comments (
	id SERIAL PRIMARY KEY,
	topic_id INTEGER NOT NULL REFERENCES topics(id),
	member_id INTEGER NOT NULL REFERENCES members(id),
	created_at TIMESTAMP NOT NULL,
	body TEXT NOT NULL
);