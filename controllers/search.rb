get "/" do
  erb :search
end

get "/results" do
  @query = URI.decode_www_form_component(params[:query])
  @results = search_engine(params[:engine], @query)
  erb :results
end

def search_engine(engine, query)
  case engine
  when "bing"
    SearchTools::Bing.search(QueryBuilder.new(query, "en-US", true, 0, 10))
  when "brave"
    SearchTools::Brave.search(QueryBuilder.new(query, "en-US", true, 0, 10))
  end
end
