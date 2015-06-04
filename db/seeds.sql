\c forum

INSERT INTO members
	(name, username, password, email, join_date)
VALUES
	('ryan', 'ryan', 'password', 'ryan@burke.com', CURRENT_TIMESTAMP),
	('teri', 'teri', 'password', 'teri@burke.com', CURRENT_TIMESTAMP),
	('bob', 'bob', 'password', 'bob@burke.com', CURRENT_TIMESTAMP),
	('meagan', 'meagan', 'password', 'meagan@burke.com', CURRENT_TIMESTAMP),
	('kailey', 'kailey', 'password', 'kailey@burke.com', CURRENT_TIMESTAMP);

INSERT INTO topics
	(title, member_id, created_at)
VALUES
	('what is for breakfast?', 3, CURRENT_TIMESTAMP),
	('what is for lunch?', 4, CURRENT_TIMESTAMP),
	('what is for dinner?', 1, CURRENT_TIMESTAMP);

INSERT INTO comments
	(topic_id, member_id, created_at, body)
VALUES
	(1, 2, CURRENT_TIMESTAMP, 'cereal'),
	(1, 3, CURRENT_TIMESTAMP, 'do we have bananas?'),
	(1, 5, CURRENT_TIMESTAMP, 'no');
