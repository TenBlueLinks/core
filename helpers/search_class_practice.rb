class Result
  def initialize(url, title, snippet)
    @url = url
    @title = title
    @snippet = snippet
  end

  def to_s
    "#{@title} (#{@url})"
  end

  def to_html
    "<a href=\"#{@url}\">#{@title}</a>
    <br/> <br/>
    #{@url}
    <br/> <br/>
    #{@snippet}
    <br/> <br/>"
  end

  attr_reader :url, :title, :snippet
end
