get "/" do
  erb :search
end

get "/results" do
  sample = Result.new("http://www.google.com", "Google", "Search the web easily with Google")
  sample2 = Result.new("http://www.bing.com", "Bing", "Search the web easily with Bing")
  @results = [sample, sample2]
  erb :results
end
