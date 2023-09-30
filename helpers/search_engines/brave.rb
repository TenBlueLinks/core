SearchEngines.add :Brave do
  url do |query|
    "https://api.search.brave.com/res/v1/web/"
      .+("search?q=#{CGI.escape query.query}")
      .+("&ui-lang=#{query.market}")
      .+("&safesearch=#{if query.safesearch then "strict" else "moderate" end}")
      .+("&offset=#{query.offset}&count=#{query.count}")
  end
  results do |response|
    response["web"]["results"].map {
      |result|
      Result.new(result["url"], result["title"], result["description"])
    }
  end
  headers do
    { "X-Subscription-Token": ENV["BRAVE_TOKEN"] }
  end
end
