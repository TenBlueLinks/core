SearchEngines.add :Brave do
  base_uri "https://api.search.brave.com/"
  endpoint "/res/v1/web/search"
  format :json
  headers "X-Subscription-Token": ENV["BRAVE_TOKEN"]
  query do |builder|
    {
      q: CGI.escape(builder.query),
      ui_lang: builder.market,
      safesearch: if builder.safesearch then "strict" else "moderate" end,
      offset: builder.offset,
      count: builder.count,
    }
  end
  results do |response|
    response["web"]["results"].map {
      |result|
      Result.new(result["url"], result["title"], result["description"])
    }
  end
end
