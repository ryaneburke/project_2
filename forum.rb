require "sinatra/base"
require "sinatra/reloader"
require "pry"

require_relative "db/connection"

module Forum
	class Server < Sinatra::Base 
		configure do
			register Sinatra::Reloader
			set :sessions, true
		end

		def current_user
			session[:user_id]
		end

		def logged_in?
			!current_user.nil?
		end



	end#Server
end#Forum