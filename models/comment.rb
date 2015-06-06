# require_relative "../db/connection"

class Comment
	attr_reader :id, :topic_id, :member_id, :created_at
	attr_accessor :body

	def initialize(attrs={})
		@id = attrs['id']
		@topic_id = attrs['topic_id']
		@member_id = attrs['member_id']
		@created_at = attrs['created_at']
		@body = attrs['body']
	end

	def Comment.all(order_by: :id)
		results = $db.exec_params("SELECT * FROM comments ORDER BY $1", [order_by]).map do |comment|
			Comment.new(comment)
		end
	end

	def Comment.add(params)
		id = $db.exec_params("INSERT INTO comments (topic_id, member_id, body, created_at) VALUES ($1, $2, $3, CURRENT_TIMESTAMP) RETURNING id", [params[:topic_id], params[:member_id], params[:body]])
		newcomment = Comment.find('id', id.first['id'])
	end

	def Comment.find(id)
		result = $db.exec_params("SELECT * FROM comments WHERE id = $1", [id]).first
		Comment.new(result)
	end

	def Comment.find_matches(attrs={})
		results = $db.exec_params("SELECT * FROM comments WHERE $1 = $2", [attributes[:target], attributes[:member_id]]).map do |comment|
			Comment.new(comment)
		end
	end

	def edit
	end

	def delete
	end

end#Comment
