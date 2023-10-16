SearchEngines.add :Bing do
  config :api_key
  base_uri "https://api.bing.microsoft.com/"
  endpoint "/v7.0/search"
  format :json
  headers "Ocp-Apim-Subscription-Key": config.api_key
  query do |builder|
    {
      q: CGI.escape(builder.query),
      mkt: builder.market,
      SafeSearch: builder.safesearch ? "strict" : "moderate",
      offset: builder.offset,
      count: builder.count,
    }
  end
  results "webPages", "value" do |r|
    url r["url"]
    title r["name"]
    snippet r["snippet"]
  end
end
