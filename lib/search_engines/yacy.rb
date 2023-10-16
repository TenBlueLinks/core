SearchEngines.add :YaCy do
  config :instance_url
  base_uri config.instance_url
  endpoint "/yacysearch.json"
  format :json
  headers Accept: "application/json"
  query do |builder|
    {
      query: CGI.escape(builder.query),
      maximumRecords: builder.count,
      resource: "global",
      verify: false,
      startRecord: ((builder.offset.to_i + 1) * builder.count),
    }
  end
  results "channels", 0, "items" do |r|
    url r["link"]
    title r["title"]
    snippet r["description"]
  end
end
