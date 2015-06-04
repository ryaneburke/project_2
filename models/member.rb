module Forum

	class Member
		attr_reader :id, 
		attr_accessor :name, :username, :email, :join_date, :location, :type
		def initialize(attrs={})
			@id = attrs['id']
			@name = attrs['name']
			@username = attrs['username']
			@email = attrs['email']
			@join_date = attrs['join_date']
			@location = attrs['location']
			@type = attrs['type']
		end

# confirm if this can take an array of hashes
# confirm if need to iterate Member creation
		def self.all
			query = "SELECT * FROM members"
			results = $db.exec(query).entries
			Member.new(results)
		end

		def self.find(id)
			query = "SELECT * FROM members WHERE id = $1"
			results = $db.exec_params(query, [id]).first
			Member.new(results)
		end

		def self.group_by(var)
			case var
			when
			when
			else
			end
		end

		def edit
		end

		def delete
		end

	end#Member
end#Forum