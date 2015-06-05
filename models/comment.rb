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

	def self.all
		results = $db.exec("SELECT * FROM comments").entries.map! do |comment|
			Comment.new(comment)
		end
	end

	def self.find(id)
		result = $db.exec_params("SELECT * FROM comments WHERE id = $1", [id]).first
		Comment.new(results)
	end

	# def self.group_by(var)
	# 	case var
	# 	when
	# 	when
	# 	else
	# 	end
	# end

	def edit
	end

	def delete
	end

end#Comment
