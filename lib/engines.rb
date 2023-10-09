# frozen_string_literal: true

require_relative "search_tools"
require_relative "dsl"

def require_search_engines(engine_name_list)
  engine_name_list.each do |engine_name|
    require_relative "search_engines/#{engine_name.downcase}"
  end
end

engines = %w[Bing Brave GitHub YaCy]
require_search_engines(engines)