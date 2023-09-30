def update_page_parameters(url)
  uri = URI(url)
  params = Hash[URI.decode_www_form(uri.query || "")]
  page = (params["page"] || "0").to_i

  prev_url = uri.dup.tap { |u| u.query = URI.encode_www_form(params.merge("page" => [page - 1, 0].max)) }
  next_url = uri.dup.tap { |u| u.query = URI.encode_www_form(params.merge("page" => page + 1)) }

  [prev_url.to_s, next_url.to_s]
end

def next_and_prev_page(url)
  prev_url, next_url = update_page_parameters(url)
  mab do
    center do
      a "<-", href: prev_url
      a "->", href: next_url
    end
  end
end
