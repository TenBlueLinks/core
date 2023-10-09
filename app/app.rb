require "sinatra/base"
require "sinatra/cookies"
# require "sinatra/reloader"
require "sinatra/static_assets"
# require "sassc"
require "rack/brotli"
require_relative "controllers"
require_relative "helpers"
require "httparty"
require "uri"
require "cgi"
require "json"
require "markaby/kernel_method"
require "drb/drb"

DRb.start_service

Engines = DRbObject.new_with_uri("druby://localhost:8787")
