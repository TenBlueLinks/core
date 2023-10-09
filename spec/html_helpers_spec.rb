require_relative "../app/helpers/html/forms"
require "markaby/kernel_method"
RSpec.describe "HTMLizer::search_form" do
  let(:query) { "example query" }
  let(:engine_name) { "example engine" }

  it "generates the default search form" do
    expected_output = <<~HTML
      <form action="/results" method="get"><input type="text" name="query" size="40" value="example query"/><input type="hidden" name="engine" value="example engine"/><input type="submit" value="Search"/></form>
    HTML

    expect(HTMLizer::search_form(query, engine_name)).to eq(expected_output.strip)
  end

  it "generates the search form with an empty query" do
    query = ""
    expected_output = <<~HTML
      <form action="/results" method="get">
        <input type="text" name="query" size="40" value="">
        <input type="hidden" name="engine" value="example engine">
        <input type="submit" value="Search">
      </form>
    HTML

    expect(HTMLizer::search_form(query, engine_name)).to eq(expected_output.strip)
  end

  it "generates the search form with an empty engine name" do
    engine_name = ""
    expected_output = <<~HTML
      <form action="/results" method="get">
        <input type="text" name="query" size="40" value="example query">
        <input type="hidden" name="engine" value="">
        <input type="submit" value="Search">
      </form>
    HTML

    expect(HTMLizer::search_form(query, engine_name)).to eq(expected_output.strip)
  end
end
