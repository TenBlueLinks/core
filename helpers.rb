def require_helpers(helper_list)
  helper_list.each do |helper|
    require_relative "helpers/#{helper}"
  end
end

# Example usage
helper_list = %w[langarray result_struct search_tools]
require_helpers(helper_list)
