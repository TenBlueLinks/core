SearchEngines.add :GitHub do
  url do |query|
    "https://api.github.com/search/"
      .+("repositories?q=#{CGI.escape query.query}")
      .+("&sort=stars")
      .+("&order=desc")
      .+("&per_page=#{query.count}")
      .+("&page=#{query.offset}")
  end
  results do |response|
    response["items"].map {
      |result|
      Result.new(result["html_url"], result["full_name"], result["description"])
    }
  end
  headers do
    { "Accept": "application/vnd.github.v3+json" }
  end
end
