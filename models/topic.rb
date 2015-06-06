# require_relative "../db/connection"

class Topic
	attr_reader :id, :member_id, :created_at
	attr_accessor :title, :ranking

	def initialize(attrs={})
		@id = attrs['id']
		@member_id = attrs['member_id']
		@created_at = attrs['created_at']
		@title = attrs['titles']
		@ranking = attrs['ranking']
	end

	def Topic.all(order_by: :id)
		results = $db.exec_params("SELECT * FROM topics ORDER BY $1", [order_by]).map do |topic|
			Topic.new(topic)
		end
	end

	def Topic.add(params)
		id = $db.exec_params("INSERT INTO topics (member_id, title, created_at) VALUES ($1, $2, CURRENT_TIMESTAMP) RETURNING id", [params[:member_id], params[:title]])
		newtopic = Topic.find('id', id.first['id'])
	end

	def Topic.find(key, val)
		result = $db.exec_params("SELECT * FROM topics WHERE #{key} = $1", [val]).first
		Topic.new(result)
	end

	def Topic.find_matches(attrs={})
		results = $db.exec_params("SELECT * FROM comments WHERE $1 = $2", [attributes[:target], attributes[:member_id]]).map do |comment|
			Comment.new(comment)
		end
	end

	def update
	end

	def delete
	end

end#Topic
