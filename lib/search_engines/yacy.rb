# frozen_string_literal: true

SearchEngines.add :YaCy do
  base_uri ENV['YACY_INSTANCE']
  endpoint '/yacysearch.json'
  format :json
  headers Accept: 'application/json'
  query do |builder|
    {
      query: CGI.escape(builder.query),
      maximumRecords: builder.count,
      resource: 'global',
      verify: false,
      startRecord: ((builder.offset + 1) * builder.count)
    }
  end
  results 'channels', 0, 'items'
  result do |i|
    url i['link']
    title i['title']
    snippet i['description']
  end
end
