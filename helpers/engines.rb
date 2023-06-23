require_relative "search_tools"

def require_search_engines(engine_name_list)
  engine_name_list.each do |engine_name|
    require_relative "search_engines/#{engine_name.downcase}"
  end
end

engines = %w[Bing Brave] #GitHub
require_search_engines(engines)

include SearchEngines

Engines = engines
  .map { |engine_name| search_engine(engine_name) }
  .reduce({}, :merge)
