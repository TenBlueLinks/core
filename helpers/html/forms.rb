module HTMLizer
  class << self
    def search_form(query)
      (Markaby::Builder.new do
        form action: "/results", method: "get" do
          input type: "text", name: "query", size: "40", value: query
          input type: "submit", value: "Search"
        end
      end).to_s
    end
  end
end
