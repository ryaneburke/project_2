# require_relative "../db/connection"

class Member
	attr_reader :id 
	attr_accessor :name, :username, :email, :join_date, :location, :status

	def initialize(attrs={})
		@id = attrs['id']
		@name = attrs['name']
		@username = attrs['username']
		@email = attrs['email']
		@join_date = attrs['join_date']
		@location = attrs['location']
		@status = attrs['status']
	end

	def self.all
		results = $db.exec("SELECT * FROM members").entries.map! do |member|
			Member.new(member)
		end
	end

	def self.find(id)
		result = $db.exec_params("SELECT * FROM members WHERE id = $1", [id]).first
		Member.new(result)
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

end#Member