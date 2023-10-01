SearchEngines.add :GitHub do
  base_uri "https://api.github.com/"
  endpoint "/search/repositories"
  format :json
  headers Accept: "application/vnd.github.v3+json"
  query do |builder|
    {
      q: CGI.escape(builder.query),
      sort: "stars",
      order: "desc",
      per_page: builder.count,
      page: builder.offset,
    }
  end
  results do |response|
    response["items"].map {
      |result|
      Result.new(result["html_url"], result["full_name"], result["description"])
    }
  end
end
