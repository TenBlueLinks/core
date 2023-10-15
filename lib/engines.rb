# frozen_string_literal: true

require_relative "search_tools"
require_relative "dsl"
require "rufus-lua"

conf = Rufus::Lua::State.new
File.read(File.expand_path("../../conf.lua", __FILE__)).then { conf.eval _1 }

Config = {
  engines: conf["engines"].to_h,
}

# Loads the search engines specified in the configuration, relying on file naming conventions.
def SearchEngines.load_engines(engine_name_list)
  engine_name_list.each do |engine_name|
    require_relative "search_engines/#{engine_name.downcase}"
  end
end

engines = %w[Bing Brave GitHub YaCy]
SearchEngines.load_engines(engines)
