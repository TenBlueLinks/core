get "/" do
  @title = "Home"
  erb :search
end

get "/results" do
  @query = URI.decode_www_form_component(params[:query])
  @title = "\"#{@query}\" Results"
  @results = search_with(params[:engine], QueryBuilder.new(@query, cookies[:where], cookies[:safesearch], 0, 10))
  erb :results
end

def search_with(name, query)
  Engines[name].search(query)
end
