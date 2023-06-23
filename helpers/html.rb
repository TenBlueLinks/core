def html_helpers(html_helpers_list)
  html_helpers_list.each do |html_helper|
    require_relative "html/#{html_helper}"
  end
end

html_helpers_list = %w[forms options]
html_helpers(html_helpers_list)
