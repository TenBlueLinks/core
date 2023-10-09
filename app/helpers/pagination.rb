# Updates the parameters of the given URL and returns the previous and next URLs.
#
# Parameters:
#   - url: A string representing the URL to update. Usually the current page of results.
#
# Returns:
#   - A list of two strings:
#     - The previous URL with the updated page parameter.
#     - The next URL with the updated page parameter.
def update_page_parameters(url)
  uri = URI(url)
  params = Hash[URI.decode_www_form(uri.query || "")]
  page = (params["page"] || "0").to_i

  prev_url = uri.dup.tap { |u| u.query = URI.encode_www_form(params.merge("page" => [page - 1, 0].max)) }
  next_url = uri.dup.tap { |u| u.query = URI.encode_www_form(params.merge("page" => page + 1)) }

  [prev_url.to_s, next_url.to_s]
end

# Generates a pagination bar with previous and next links.
#
# Parameters:
# - url (String): The URL of the current page.
#
# Returns:
# - String: The pagination bar.
def next_and_prev_page(url)
  prev_url, next_url = update_page_parameters(url)
  mab do
    center do
      a "<-", href: prev_url
      a "->", href: next_url
    end
  end
end
