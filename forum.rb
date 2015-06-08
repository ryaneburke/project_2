require "sinatra/base"
require "sinatra/reloader"
require "pry"
require "redcarpet"
require "net/http"
require "json"

require_relative "db/connection"
require_relative "models/comment"
require_relative "models/member"
require_relative "models/topic"

module Forum
	class Server < Sinatra::Base 

		MARKDOWN = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)

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
			!currentuser_id.nil?
		end

#WELCOME
		get '/' do
			if logged_in?
				redirect '/topics'
			else
				erb :welcome
			end
		end

#MEMBERS
		get '/members' do
			@members = Member.all
			if logged_in?
				erb :in_members
			else
				erb :members
			end
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

		#LOGOUT
		delete '/logout' do
      session[:user_id] = nil
      session[:username] = nil
      redirect '/'
    end


		#PROFILE PAGE
		get '/members/:id' do
			@member = Member.find(params[:id])
			erb :profile
		end


#TOPICS
		#SHOW ALL TOPICS
		get '/topics' do
			@topics = Topic.all
			@topics.map do |topic|
				topic.get_author
			end
			if logged_in?
				erb :in_topics
			else	
				erb :topics
			end
		end

		#TOPIC PAGE WITH ALL COMMENTS
		get '/topics/:id' do
			@topic = Topic.single_topic(params)
			@comments = Comment.single_topic(params)
			@comments.map do |comment|
				comment.render_location
			end
			if logged_in?
				erb :in_topic
			else
				erb :topic
			end
		end

		#NEW TOPIC
		post '/topics' do
			newtopic = Topic.add(params)
			redirect "/topics/#{newtopic.id}"
		end

#COMMENTS
		#SHOW ALL COMMENTS
		get '/comments' do
			@comments = Comment.all
			@comments.map do |comment|
				comment.render_location
				comment.get_topic_title
			end
			if logged_in?
				erb :in_comments
			else	
				erb :comments
			end
		end

		#NEW COMMENT, IN REFERENCE TO CURRENT TOPIC
		post '/comments' do
			newcomment = Comment.add(params)
			redirect "/topics/#{newcomment.topic_id}"
		end

		#UPDATE COMMENT
		post '/updatecomment' do
			edited = Comment.edit(params)
			redirect '/topics/#{edited.topic_id}'
		end

		#DELETE COMMENT
		delete '/xcomment' do
      session[:user_id] = nil
      session[:username] = nil
      redirect '/'
    end

	end#Server
end#Forum