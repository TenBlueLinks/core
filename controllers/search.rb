get "/" do
  @title = "Home"
  erb :search
end

get "/results" do
  @query = URI.decode_www_form_component(params[:query])
  @title = "\"#{@query}\" Results"
  @engine = params[:engine]
  @results = search_with(params[:engine], QueryBuilder.new(@query, cookies[:where], cookies[:safesearch], (params[:page] || 0), 10))
  @next_page = update_page_parameter(request.url)
  erb :results
end

def search_with(name, query)
  Engines[name.to_sym][1].call(query)
end

def update_page_parameter(url)
  uri = URI(url)
  params = Hash[URI.decode_www_form(uri.query || "")]
  params["page"] = (params["page"] || "0").to_i + 1
  uri.query = URI.encode_www_form(params)
  uri.to_s
end
