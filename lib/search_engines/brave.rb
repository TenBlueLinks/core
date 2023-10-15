SearchEngines.add :Brave do
  base_uri "https://api.search.brave.com/"
  endpoint "/res/v1/web/search"
  format :json
  headers "X-Subscription-Token": config.api_key
  query do |builder|
    {
      q: CGI.escape(builder.query),
      ui_lang: builder.market,
      safesearch: builder.safesearch ? "strict" : "moderate",
      offset: builder.offset,
      count: builder.count,
    }
  end
  results "web", "results"
  result do |i|
    url i["url"]
    title i["title"]
    snippet i["description"]
  end
end
