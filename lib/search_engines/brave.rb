SearchEngines.add :Brave do
  config :api_key
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
  results "web", "results" do |r|
    url r["url"]
    title r["title"]
    snippet r["description"]
  end
end
