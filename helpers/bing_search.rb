require "httparty"
require "uri"
require "cgi"
require "json"

module SearchTools
  module Bing
    def self.search(query)
    end

    def self.url(querybuilder)
      "https://api.bing.microsoft.com/v7.0/search?q=#{CGI.escape(querybuilder.query)}&mkt=#{querybuilder.market}&safeSearch=#{querybuilder.safesearch}&offset=#{querybuilder.offset}&count=#{querybuilder.count}"
    end

    def self.results_parse(response)
      response["webPages"]["value"].map do |result|
        Result.new(result["url"], result["name"], result["snippet"])
      end
    end

    def self.headers
      { "Ocp-Apim-Subscription-Key": ENV["BING_API_KEY"] }
    end
  end

  module Brave
    def self.headers
      { "X-Subscription-Token": ENV["BRAVE_TOKEN"] }
    end
  end
end

QueryBuilder = Struct.new(:query, :market, :safesearch, :offset, :count)
