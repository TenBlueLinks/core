require "httparty"
require "uri"
require "cgi"
require "json"
require "markaby"

QueryBuilder = Struct.new(:query, :market, :safesearch, :offset, :count)
Result = Struct.new(:url, :title, :snippet)

module ResultTools
  def self.to_html(result)
    (Markaby::Builder.new do
      a(result.title, href: result.url)
      br
      br
      text result.url
      br
      br
      text result.snippet
      br
      br
    end).to_s
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
    { name.downcase => Object.const_get("#{name}SearchEngine").new }
  end
end
