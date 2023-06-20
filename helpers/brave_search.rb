module SearchTools
  module Brave
    def self.headers
      { "X-Subscription-Token": ENV["BRAVE_TOKEN"] }
    end

    def self.url(query)
      "https://api.search.brave.com/res/v1/web/search?q=#{CGI.escape query.query}&ui-lang=#{query.market}&safesearch=#{if query.safesearch then "strict" else "moderate" end}&offset=#{query.offset}&count=#{query.count}"
    end
    def self.search(query)
      results_parse(JSON.parse(HTTParty.get(url(query), headers: headers()).body))
    end
    def self.results_parse(response)
      response["web"]["results"].map do |result|
        Result.new(result["url"], result["title"], result["description"])
      end
    end
  end
end
