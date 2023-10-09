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
  results "items"
  result do |i|
    url i["html_url"]
    title i["full_name"]
    snippet i["description"]
  end
end
