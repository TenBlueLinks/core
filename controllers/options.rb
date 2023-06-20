get "/options" do
  if params[:safesearch]
    cookies[:safesearch] = params[:safesearch]
  end
  if params[:where]
    cookies[:where] = params[:where]
  end
  @where = cookies[:where] ? cookies[:where] : "en-US"
  erb :options, :locals => { :options => langarray() }
end

get "/options/view" do
  erb :options_view, layout: :layout
end

get "/options/save" do
  cookies[:safesearch] = params[:safesearch]
  cookies[:where] = params[:where]
  redirect "/options/view"
end
