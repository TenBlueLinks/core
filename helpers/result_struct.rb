module ResultTools
  def to_html(result)
    "<a href=\"#{result.url}\">#{result.title}</a>
    <br/> <br/>
    #{result.url}
    <br/> <br/>
    #{result.snippet}
    <br/> <br/>"
  end
end

Result = Struct.new(:url, :title, :snippet)
