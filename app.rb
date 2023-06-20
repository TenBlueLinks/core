require "sinatra"
require "sinatra/cookies"
# require "sinatra/reloader"
require "sinatra/static_assets"
require_relative "controllers"
require_relative "helpers"

set :server, "webrick"
