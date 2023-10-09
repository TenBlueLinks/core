%w(engines dsl search_tools).each do |file|
  require_relative file
end

require "drb/drb"

DRb.start_service "druby://localhost:8787", SearchEngines

DRb.thread.join
