require "httparty"
require "uri"
require "cgi"
require "json"

QueryBuilder = Struct.new(:query, :market, :safesearch, :offset, :count)
Result = Struct.new(:url, :title, :snippet)

module ResultTools
  def self.to_html(result)
    "<a href=\"#{result.url}\">#{result.title}</a>
    <br/> <br/>
    #{result.url}
    <br/> <br/>
    #{result.snippet}
    <br/> <br/>"
  end
end

class SearchEngine
  attr_accessor :name

  def search(query)
    raise NotImplementedError, "Subclasses must implement the 'search' method."
  end
end

module SearchEngines
  def search_engine(name)
    engine_class = Object.const_get("#{name}SearchEngine")
    engine = engine_class.new
    { name.downcase => engine }
  end
end
