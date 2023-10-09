# frozen_string_literal: true

require "httparty"
require "uri"
require "cgi"
require "json"
require "markaby/kernel_method"

=begin
A struct which represents a query to a search engine.
@author Shreyan Jain
@see SearchEngines::ISO3166
@!attribute query [rw]
  @return [String] the string being searched for.
@!attribute market [rw]
  @return [String] the market to search in, as defined by ISO 3166. See {SearchEngines::ISO3166}
@!attribute safesearch [rw]
  @return [Boolean] whether to use safe search or not.
@!attribute offset [rw]
  @return [Integer] the offset of the search results. Used for pagination.
@!attribute count [rw]
  @return [Integer] the number of results to return. Usually Ten Blue Ones ;)
=end
QueryBuilder = Struct.new(:query, :market, :safesearch, :offset, :count)

=begin
A struct which represents a search result. Will be documented much better soon.
@author Shreyan Jain
@!attribute url [r]
  @return [String] the URL of the search result.
@!attribute title [r]
  @return [String] the title of the search result.
@!attribute snippet [r]
  @return [String] the snippet of the search result.
=end
Result = Struct.new(:url, :title, :snippet) do
  # @return [String] An HTML representation of the search result, to be rendered in the results page.
  def to_html
    res = self
    mab do
      a(res.title, href: res.url)
      2.times { br }
      text res.url
      2.times { br }
      text res.snippet
      2.times { br }
    end
  end
end
