get "/options" do
  @title = "Edit Options"
  erb :options, :locals => { :options => langhash() }
end

get "/options/view" do
  @title = "View Options"
  erb :options_view, layout: :layout
end

get "/options/save" do
  cookies[:safesearch] = params[:safesearch]
  cookies[:where] = params[:where]
  redirect "/options/view"
end
