module BingSearchEngine
  class << self
    def search(query)
      results_parse(JSON.parse(HTTParty.get(url(query), headers: headers).body))
    end

    private

    def results_parse(response)
      response["webPages"]["value"].map do |result|
        Result.new(result["url"], result["name"], result["snippet"])
      end
    end

    def url(querybuilder)
      "https://api.bing.microsoft.com/v7.0/search?q=#{CGI.escape(querybuilder.query)}&mkt=#{querybuilder.market}&safeSearch=#{if querybuilder.safesearch then "strict" else "moderate" end}&offset=#{querybuilder.offset}&count=#{querybuilder.count}"
    end

    def headers
      { "Ocp-Apim-Subscription-Key": ENV["BING_API_KEY"] }
    end
  end
end
