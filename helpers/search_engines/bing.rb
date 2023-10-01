SearchEngines.add :Bing do
  base_uri "https://api.bing.microsoft.com/"
  endpoint "/v7.0/search"
  format :json
  headers "Ocp-Apim-Subscription-Key": ENV["BING_API_KEY"]
  query do |builder|
    {
      q: CGI.escape(builder.query),
      mkt: builder.market,
      SafeSearch: if builder.safesearch then "strict" else "moderate" end,
      offset: builder.offset,
      count: builder.count,
    }
  end
  results do |response|
    response["webPages"]["value"].map {
      |result|
      Result.new(result["url"], result["name"], result["snippet"])
    }
  end
end
