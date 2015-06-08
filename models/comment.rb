# require_relative "../db/connection"

require 'pry'
require 'net/http'
require 'json'

class Comment
	attr_reader :id, :topic_id, :member_id, :created_at
	attr_accessor :body, :ip, :author, :avatar, :member_status, :location, :topic_title

	def initialize(attrs={})
		@id = attrs['id']
		@topic_id = attrs['topic_id']
		@member_id = attrs['member_id']
		@author = attrs['author']
		@avatar = attrs['avatar']
		@member_status = attrs['member_status']
		@created_at = attrs['created_at']
		@ip = attrs['ip']
		@body = attrs['body']
	end

	def Comment.all(order_by: :id)
		results = $db.exec_params("SELECT comments.*, members.username AS author, members.img_url AS avatar, members.status AS member_status FROM comments JOIN members ON members.id = comments.member_id WHERE comments.member_id > 0 ORDER BY $1", [order_by]).map do |comment|
			Comment.new(comment)
		end
	end

	def Comment.add(params)
		id = $db.exec_params("INSERT INTO comments (body, topic_id, ip, member_id, created_at) VALUES ($1, $2, $3, $4, CURRENT_TIMESTAMP) RETURNING id", [params[:body], params[:topic_id].to_i, params[:ip], params[:member_id].to_i]).first
		newcomment = Comment.find(id['id'])
	end

	def Comment.find(id)
		result = $db.exec_params("SELECT * FROM comments WHERE id = $1", [id]).first
		Comment.new(result)
	end

	def Comment.single_topic(params)
		results = $db.exec_params("SELECT comments.*, members.username AS author, members.img_url AS avatar, members.status AS member_status FROM comments JOIN members ON members.id = comments.member_id WHERE comments.topic_id = $1", [params[:id]])
		results.map do |comment|
			Comment.new(comment)
		end
	end

	def Comment.update(params)
		$db.exec_params("UPDATE comments SET body = $1 WHERE id = $2", [params[:body], params[:id]])
		Comment.new(params[:id])
	end

	def Comment.delete(params)
		$db.exec_params("DELETE FROM comments WHERE id = $1", [params[:id]])
	end

	def render_location
		uri = URI("http://ipinfo.io/#{@ip}/geo")
		result = Net::HTTP.get(uri)
		data = JSON.parse(result)
		if data['city'].nil?
			@location = 'Local Host'
		else
			@location = "#{data['city']}, #{data['region']}, #{data['country']}"
		end
	end

	def get_topic_title
		result = $db.exec("SELECT * FROM topics WHERE id = #{@topic_id}").first
		@topic_title = result['title']
	end

	def get_author
		result = $db.exec("SELECT * FROM members WHERE id = #{@member_id}").first
		@author = result['username']
	end

end#Comment
