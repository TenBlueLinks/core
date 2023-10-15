SearchEngines.add :Bing do
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
  results "webPages", "value"
  result do |i|
    url i["url"]
    title i["name"]
    snippet i["snippet"]
  end
end
