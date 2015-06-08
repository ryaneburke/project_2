# require_relative "../db/connection"

require 'pry'

class Topic
	attr_reader :id, :member_id, :created_at
	attr_accessor :title, :ranking, :ip, :author

	def initialize(attrs={})
		@id = attrs['id']
		@member_id = attrs['member_id']
		@created_at = attrs['created_at']
		@title = attrs['title']
		@ranking = attrs['ranking']
		@ip = attrs['ip']
		@author = attrs['author']
	end

	def Topic.all(order_by: :id)
		results = $db.exec_params("SELECT * FROM topics ORDER BY $1", [order_by]).map do |topic|
			Topic.new(topic)
		end
	end

	def Topic.add(params)
		id = $db.exec_params("INSERT INTO topics (member_id, title, ip, created_at) VALUES ($1, $2, $3, CURRENT_TIMESTAMP) RETURNING id", [params[:member_id], params[:title], params[:ip]]).first
		newtopic = Topic.find(id['id'])
	end

	def Topic.find(id)
		result = $db.exec_params("SELECT * FROM topics WHERE id = $1", [id]).first
		Topic.new(result)
	end

	def Topic.single_topic(params)
		result = $db.exec_params("SELECT topics.*, members.username AS author FROM topics JOIN members ON members.id = topics.member_id WHERE topics.id = $1", [params[:id]]).first
		Topic.new(result)
	end

	def get_author
		result = $db.exec("SELECT * FROM members where id = #{@member_id}").first
		@author = result['username']
	end

# For use on member profile page
	# def Topic.find_matches(params)
	# 	results = $db.exec_params("SELECT * FROM topics WHERE member_id = $1", [params['id']])
	# 	if results.nil?
	# 		nil
	# 	elsif	results.length >= 1
	# 		results.map do |topic|
	# 			Topic.new(topic)
	# 		end
	# 	else
	# 		Topic.new(results.first)
	# 	end
	# end

	def update
	end

	def delete
	end

end#Topic
