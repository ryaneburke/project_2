# require_relative "../db/connection"

class Member
	attr_reader :id 
	attr_accessor :name, :username, :email, :join_date, :location, :status, :img_url, :status

	def initialize(attrs={})
		@id = attrs['id']
		@name = attrs['name']
		@username = attrs['username']
		@email = attrs['email']
		@join_date = attrs['join_date']
		@img_url = attrs['img_url']
		@location = attrs['location']
		@status = attrs['status']
	end

	def Member.all(order_by: :id)
		results = $db.exec_params("SELECT * FROM members ORDER BY $1", [order_by]).map do |member|
			Member.new(member)
		end
	end

	def Member.add(params)
		id = $db.exec_params("INSERT INTO members (name, username, password, email, join_date) VALUES ($1, $2, $3, $4, CURRENT_TIMESTAMP) RETURNING id", [params[:name], params[:username], params[:password], params[:email]])
		newmember = Member.find('id', id.first['id'])
	end

	def Member.find(key, val)
		result = $db.exec_params("SELECT * FROM members WHERE #{key} = $1", [val]).first
		Member.new(result)
	end

	def Member.username_unique?(username)
		check = $db.exec_params("SELECT * FROM members WHERE username = $1", [username]).first
		if check.nil?
			true
		end
	end

	def Member.login(params)
		member = $db.exec_params("SELECT * FROM members WHERE username = $1 AND password = $2", [params[:username], params[:password]]).first
		Member.new(member)
	end

	# def update(changes={})
	# 	@name = changes['name'] || @name
	# 	@username = changes['username'] || @username
	# 	@email = changes['email'] || @email
	# 	@status = changes['status'] || @status
	# end

	# def save
	# 	$db.exec_params("UPDATE members SET --these values -- WHERE id = $6", [array of things to change])
	# end

	# def delete
	# end

end#Member