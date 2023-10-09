%w(engines dsl search_tools langhash).each &method(:require_relative)

require "drb/drb"

DRb.start_service "druby://localhost:8787", SearchEngines

DRb.thread.join
