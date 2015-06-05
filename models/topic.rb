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

	def self.all
		results = $db.exec("SELECT * FROM topics").entries.map! do |topic|
			Topic.new(topic)
		end
	end

	def self.find(id)
		result = $db.exec_params("SELECT * FROM topics WHERE id = $1", [id]).first
		Topic.new(result)
	end

	# def self.group_by(var)
	# 	case var
	# 	when
	# 	when
	# 	else
	# 	end
	# end

	def upvote
		@ranking += 1
	end

	def downvote
		@ranking -= 1
	end

	def edit
	end

	def delete
	end
	
end

end#Topic
