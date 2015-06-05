require "sinatra/base"
require "sinatra/reloader"
require "pry"

require_relative "db/connection"
require_relative "models/comment"
require_relative "models/member"
require_relative "models/topic"

module Forum
	class Server < Sinatra::Base 

		configure do
			register Sinatra::Reloader
			set :sessions, true
		end

		def currentuser_id
			session[:id]
		end

		def currentuser_username
			session[:username]
		end

		def logged_in?
			@currentuser_id.nil?
		end

#WELCOME
		get '/' do
			erb :welcome
		end

#MEMBERS
		get '/members' do
			@members = $db.exec("SELECT * FROM members")
			erb :members
		end

		#LOGIN
		post '/members/login' do
			@member = $db.exec_params("SELECT * FROM members WHERE username = $1 AND password = $2", [params[:username], params[:password]])
			member_id = @member.first['id']
			username = @member.first['username']
			if member_id.nil?
				@message = "Invalid Login. Please check your input and try again."
				erb :welcome
			else
				session[:username] = username
				session[:id] = member_id
				redirect '/topics'
			end
		end

		#CREATE MEMBER
		post '/members' do
			password = params[:password]
			verification = params[:verification]
			if password != verification
				@message = "Passwords did not match. Please register again."
				redirect '/' 
			else
				# check = $db.exec_params("SELECT * FROM members WHERE username = $1", [params[:username]]).first
				# if check.nil?
				# 	@message = "Username already exists. Please try another."
				# 	redirect '/'
				# else
					query = "INSERT INTO members (name, username, password, email, join_date) VALUES ($1, $2, $3, $4, CURRENT_TIMESTAMP) RETURNING id"
					id = $db.exec_params(query, [params[:name], params[:username], params[:password], params[:email]])
					redirect "/members/#{id.first['id']}"
				# end
			end
		end

		#PROFILE PAGE
		get '/members/:id' do
			binding.pry
			query = "SELECT * FROM members WHERE id = $1"
			@member = $db.exec_params(query, [params[:id]]).first
			erb :profile
		end


#TOPICS
		#SHOW ALL TOPICS
		get '/topics' do
			@topics = $db.exec("SELECT * FROM topics")
			erb :topics
		end

		#TOPIC PAGE WITH ALL COMMENTS
		get '/topics/:id' do
			@topic = $db.exec_params("SELECT topics.* FROM topics WHERE id = $1", [params[:id]]).first
			@comments = $db.exec_params("SELECT comments.*, members.username AS author, members.img_url AS avatar FROM comments JOIN members ON members.id = comments.member_id WHERE comments.topic_id = $1", [params[:id]])
			erb :topic
		end

#COMMENTS
		#SHOW ALL COMMENTS
		get '/comments' do
			@comments = $db.exec("SELECT * FROM comments")
			erb :comments
		end

		#POST COMMENT, IN REFERENCE TO CURRENT TOPIC
		post '/comments' do
			body = @params[:body]
			topic_id = @params[:topic_id]
			member_id = currentuser_id
			query = "INSERT INTO comments (body, topic_id, member_id, created_at) VALUES ($1, $2, $3, CURRENT_TIMESTAMP)"
			$db.exec_params(query, [body, topic_id, member_id])
			redirect '/topics/#{topic_id}'
		end


	end#Server
end#Forum