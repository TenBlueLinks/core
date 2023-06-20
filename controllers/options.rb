get "/options" do
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
