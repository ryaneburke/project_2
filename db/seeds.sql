
\c forum

INSERT INTO members
	(name, username, password, email, join_date)
VALUES
	('ryan', 'ryan', 'password', 'ryan@burke.com', CURRENT_TIMESTAMP),
	('teri', 'teri', 'password', 'teri@burke.com', CURRENT_TIMESTAMP),
	('bob', 'bob', 'password', 'bob@burke.com', CURRENT_TIMESTAMP),
	('meagan', 'meagan', 'password', 'meagan@burke.com', CURRENT_TIMESTAMP),
	('kailey', 'kailey', 'password', 'kailey@burke.com', CURRENT_TIMESTAMP),
	('rocco', 'rocco', 'password', 'rocco@russo.com', CURRENT_TIMESTAMP),
	('winnie', 'winnie', 'password', 'winnie@russo.com', CURRENT_TIMESTAMP),
	('len', 'len', 'password', 'len@mitchell.com', CURRENT_TIMESTAMP),
	('janet', 'janet', 'password', 'janet@mitchell.com', CURRENT_TIMESTAMP);

INSERT INTO topics
	(title, member_id, created_at, ip)
VALUES
	('what is for breakfast?', 3, CURRENT_TIMESTAMP, '20.61.147.91'),
	('what is for lunch?', 4, CURRENT_TIMESTAMP, '188.206.40.145'),
	('what is for dinner?', 1, CURRENT_TIMESTAMP, '173.148.85.109'),
	('AAAAAAAA', 2, CURRENT_TIMESTAMP, '88.160.190.49'),
	('BBBBBBBB', 1, CURRENT_TIMESTAMP, '173.148.85.109'),
	('CCCCCCCC', 1, CURRENT_TIMESTAMP, '173.148.85.109'),
	('DDDDDDDD', 1, CURRENT_TIMESTAMP, '173.148.85.109'),
	('EEEEEEEE', 3, CURRENT_TIMESTAMP, '20.61.147.91');

INSERT INTO comments
	(topic_id, member_id, created_at, ip, body)
VALUES
	(1, 2, CURRENT_TIMESTAMP, '88.160.190.49', 'cereal'),
	(1, 3, CURRENT_TIMESTAMP, '20.61.147.91', 'do we have bananas?'),
	(1, 5, CURRENT_TIMESTAMP, '28.42.204.40', 'no'),
	(3, 2, CURRENT_TIMESTAMP, '88.160.190.49', 'asdf'),
	(3, 3, CURRENT_TIMESTAMP, '20.61.147.91', 'jkl'),
	(4, 4, CURRENT_TIMESTAMP, '188.206.40.145', 'aaa'),
	(4, 5, CURRENT_TIMESTAMP, '28.42.204.40', 'bbb'),
	(5, 1, CURRENT_TIMESTAMP, '173.148.85.109', 'ccc'),
	(5, 2, CURRENT_TIMESTAMP, '88.160.190.49','ddd'),
	(5, 5, CURRENT_TIMESTAMP, '28.42.204.40', 'sports');
