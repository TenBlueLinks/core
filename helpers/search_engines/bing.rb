SearchEngines.add :Bing do
  url do |query|
    "https://api.bing.microsoft.com/v7.0/"
      .+("search?q=#{CGI.escape(query.query)}")
      .+("&mkt=#{query.market}")
      .+("&safeSearch=#{if query.safesearch then "strict" else "moderate" end}")
      .+("&offset=#{query.offset}&count=#{query.count}")
  end
  results do |response|
    response["webPages"]["value"].map {
      |result|
      Result.new(result["url"], result["name"], result["snippet"])
    }
  end
  headers do
    { "Ocp-Apim-Subscription-Key": ENV["BING_API_KEY"] }
  end
end
