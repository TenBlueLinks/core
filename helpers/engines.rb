require_relative "search_tools"

def require_search_engines(engine_name_list)
  engine_name_list.each do |engine_name|
    require_relative "search_engines/#{engine_name.downcase}"
  end
end

engines = %w[Bing Brave] #GitHub
require_search_engines(engines)

Engines = engines
  .map { |engine_name| SearchEngines.search_engine(engine_name, &Object.const_get("#{engine_name}SearchEngine").method(:search)) }
  .reduce({}, :merge)
