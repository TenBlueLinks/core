def require_helpers(helper_list)
  helper_list.each do |helper|
    require_relative "helpers/#{helper}"
  end
end

require_relative "../lib/search_tools"

helper_list = %w[html pagination]
require_helpers(helper_list)
