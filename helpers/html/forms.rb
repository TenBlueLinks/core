module HTMLizer
  class << self
    def search_form(query, engine_name)
      mab do
        form action: "/results", method: "get" do
          input type: "text", name: "query", size: "40", value: query
          input type: "hidden", name: "engine", value: engine_name
          input type: "submit", value: "Search"
        end
      end
    end
  end
end
