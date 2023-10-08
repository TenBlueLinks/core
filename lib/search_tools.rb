# frozen_string_literal: true

require 'httparty'
require 'uri'
require 'cgi'
require 'json'
require 'markaby/kernel_method'

QueryBuilder = Struct.new(:query, :market, :safesearch, :offset, :count)
Result = Struct.new(:url, :title, :snippet) do
  # @return [String]
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
