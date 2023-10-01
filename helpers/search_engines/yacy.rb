SearchEngines.add :YaCy do
  base_uri ENV["YACY_INSTANCE"]
  endpoint "/yacysearch.json"
  format :json
  headers Accept: "application/json"
  query do |builder|
    {
      query: CGI.escape(builder.query),
      maximumRecords: builder.count,
      :resource => "global",
      :verify => false,
      startRecord: ((builder.offset + 1) * builder.count),
    }
  end
  results do |response|
    response["channels"][0]["items"].map { |result| Result.new(result["link"], result["title"], result["description"]) }
  end
end
