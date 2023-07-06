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
      2.times { br }
      text result.url
      2.times { br }
      text result.snippet
      2.times { br }
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
  def self.search_engine(name, &search_block)
    { name.downcase.to_sym => [name, search_block] }
  end
end
