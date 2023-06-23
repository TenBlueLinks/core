class GitHubSearchEngine < SearchEngine
  def search(query)
    results_parse(JSON.parse(HTTParty.get(url(query)).body))
  end

  def url(query)
    "https://api.github.com/search/repositories?q=#{CGI.escape query.query}&sort=stars&order=desc&per_page=#{query.count}&page=#{query.offset}"
  end

  def results_parse(response)
    response["items"].map {
      |result|
      Result.new(result["html_url"], result["full_name"], result["description"])
    }
  end
end
