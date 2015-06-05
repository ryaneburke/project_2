require "sinatra/base"
require "sinatra/reloader"
require "pry"

require_relative "db/connection"
require_relative "models/comment"
require_relative "models/member"
require_relative "models/topic"

module Forum
	class Server < Sinatra::Base 

		# MARKDOWN

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
			@members = Member.all
			erb :members
		end

		#NEW MEMBER
		post '/members' do
			password = params[:password]
			verification = params[:verification]
			if password != verification
				@message = "Passwords did not match. Please register again."
				erb :welcome 
			else
				if !Member.username_unique?(params[:username])
					@message = "Username already exists. Please try another."
					erb :welcome
				else
					newmember = Member.add(params)
					redirect "/members/#{newmember.id}"
				end
			end
		end

		#LOGIN
		post '/members/login' do
			member = Member.login(params)
			if member
				session[:username] = member.username
				session[:id] = member.id
				redirect '/topics'
			else
				@message = "Invalid Login. Please check your input and try again."
				erb :welcome
			end
		end


		#PROFILE PAGE
		get '/members/:id' do
			@member = Member.find('id', params[:id])
			@topics = Topic.find('member_id', @member.id)
			@

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

		#NEW TOPIC
		post '/topics' do
			title = @params[:title]
			@params[:member_id] = currentuser_id
			query = "INSERT INTO comments (title, member_id, created_at) VALUES ($1, $2, CURRENT_TIMESTAMP) RETURNING id"
			id = $db.exec_params(query, [title, member_id])
			redirect "/topics/#{id.first['id']}"
		end

#COMMENTS
		#SHOW ALL COMMENTS
		get '/comments' do
			@comments = $db.exec("SELECT * FROM comments")
			erb :comments
		end

		#NEW COMMENT, IN REFERENCE TO CURRENT TOPIC
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