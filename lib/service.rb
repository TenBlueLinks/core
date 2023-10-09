%w(engines dsl search_tools langhash).each do |f|
  require_relative f
end

require "drb/drb"

DRb.start_service "druby://localhost:8787", SearchEngines

DRb.thread.join
