# frozen_string_literal: true

require_relative "search_tools"
require_relative "dsl"
require "rufus-lua"

conf = Rufus::Lua::State.new
File.read(File.expand_path("../../conf.lua", __FILE__)).then { conf.eval _1 }

# The configuration from the conf.lua file, which will be loaded and registered.
Config = {
  engines: conf["engines"].to_h,
}

# Loads the search engines specified in the configuration, relying on file naming conventions.
def SearchEngines.load_engines(engine_name_list)
  engine_name_list.each do |engine_name|
    require_relative "search_engines/#{engine_name.downcase}"
  end
end

# The list of search engines enabled in your config file, which will be loaded and registered.
SearchEngines::EnginesList = conf["engines"].to_h.keys
SearchEngines.load_engines(SearchEngines::EnginesList)
