def require_helpers(helper_list)
  helper_list.each do |helper|
    require_relative "helpers/#{helper}"
  end
end

helper_list = %w[langarray engines]
require_helpers(helper_list)
