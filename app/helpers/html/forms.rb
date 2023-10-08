module HTMLizer
  class << self
    # Generates a search form HTML code block, for initiating a second search, from the results page.
    #
    # @param query [String] the search query of the current page
    # @param engine_name [String] the name of the search engine
    # @return [String] the HTML code block of the search form
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
