# frozen_string_literal: true

# This file contains the DSL for the search engine configuration.
#
module SearchEngines
  # A hash to store search engine configurations
  @engines = {}

  # Adds a search engine to the list of available engines.
  #
  # Parameters:
  # - engine_name (Symbol): The name of the engine.
  # - block (Proc): A block of code representing the search engine configuration.
  def self.add(engine_name, &block)
    engine = Class.new(SearchEngineBuilder)
    engine.module_exec(&block)
    @engines[engine_name.downcase.to_sym] = [engine_name, engine.new.method(:search).to_proc]
  end

  def self.[](engine_name)
    @engines[engine_name.downcase.to_sym]
  end

  def self.each(&block)
    @engines.each(&block)
  end

  class << self
    include Enumerable
  end

  # Returns the engines hash.
  #
  # @return [Hash<Symbol, Array<Symbol, Proc>>]: The engines hash
  def self.engines
    @engines
  end

  class SearchEngineBuilder
    include HTTParty
    attr_accessor :url_block, :results_block, :headers_block, :result_mapping

    class << self
      # Defines an endpoint method that returns the given string.
      # This is the endpoint of your search engine's API that HTTParty will call.
      def endpoint(string)
        define_method(:endpoint) { string }
      end

      def query(&block)
        define_method(:query, &block)
      end

      def results(*result_mapping)
        define_method(:results) { result_mapping }
      end

      def result(&block)
        define_method(:result_mapping) { block }
      end
    end

    # Searches the configured search engine with the given query. When adding your own search engine, you may redefine this, as long as it works with the appropriate types.
    # @param [QueryBuilder] query_builder: The query builder you are searching with.
    #
    # @return [Array<Result>]: An array of search results (depends on the search engine).
    # In order to map the results, use the `result_mapping` block.
    def search(query_builder)
      map_results(self.class.get(endpoint, query: query(query_builder)))
    end

    private

    # Maps the results of a response.
    # @param [HTTParty::Response] response: The HTTP response from calling the defined endpoint. Should contain a `results` key you want to map.
    # @return [Array<Result>]: An array of mapped results if result_mapping is defined.
    def map_results(response)
      result_data = deep_fetch(response, results)
      if result_mapping
        result_data.map { |item| map_result(item) }
      else
        result_data
      end
    end

    def map_result(item)
      if result_mapping
        ResultMapper.new(item, &result_mapping).map
      else
        item
      end
    end

    def deep_fetch(hsh, keys)
      keys.reduce(hsh) { |h, key| h[key] }
    end
  end

  class ResultMapper
    def initialize(item, &block)
      @item = item
      @mapping_block = block
    end

    # Evaluates the given block in the context of the current instance. The block is expected to contain a mapping logic that assigns values to instance variables, usually by using the `url`, `title`, and `snippet` methods. After evaluating the block, the method creates a new `Result` object with the values assigned to `@url`, `@title`, and `@snippet`.
    #
    # @return [Result] The newly created `Result` object.
    def map
      instance_eval(&@mapping_block)
      Result.new(@url, @title, @snippet)
    end

    def url(value)
      @url = value
    end

    def title(value)
      @title = value
    end

    def snippet(value)
      @snippet = value
    end

    def [](key)
      @item[key]
    end
  end
end
