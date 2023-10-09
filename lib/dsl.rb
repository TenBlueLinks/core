# frozen_string_literal: true

# This file contains the DSL for the search engine configuration.
#
module SearchEngines
  # A hash to store search engine configurations
  @engines = {}

  # Adds a search engine to the list of available engines.
  #
  # @param [Symbol] engine_name The name of the engine.
  # @param [Proc] block A block of code representing the search engine configuration.
  def self.add(engine_name, &block)
    engine = Class.new(SearchEngineBuilder)
    engine.module_exec(&block)
    @engines[engine_name.downcase.to_sym] = [engine_name, engine.new.method(:search).to_proc]
  end

  # @return [Array<Symbol, Proc>] An array. The first element is the human-friendly name of the engine. The second element is a proc that takes a query builder and returns an array of search results.
  def self.[](engine_name)
    @engines[engine_name.downcase.to_sym]
  end

  # Searches for a specific query using the specified search engine.
  # The query should be a QueryBuilder object.
  # This is in order to store all the different parameters of the search in one place.
  # That way, the query the search API recieves should be fit exactly to its specifications, to enable
  # easy SafeSearch, choice of language/market, pagination, etc.
  #
  # @param [String, #to_sym] name The name of the search engine.
  # @param [QueryBuilder] query The search query.
  # @return [Array<Result>] An array of search results (depends on the search engine).
  def self.search_with(name, query)
    engines[name.to_sym][1].call(query)
  end

  def self.each(&block)
    @engines.each(&block)
  end

  class << self
    include Enumerable
  end

  # Returns the engines hash.
  #
  # @return [Hash<Symbol, Array<Symbol, Proc>>] The engines hash
  def self.engines
    @engines
  end

  # A class that your search engine should inherit from.
  # This is the base class for all search engines.
  # By default, this class provides a robust DSL you can use to craft the different pieces
  # of your search engine that must come together to satisfy the requirements of the default
  # {#search} method. However, you may redefine the {#search} method to suit your needs, as long as
  # it takes a {QueryBuilder} as an argument and returns an array of {Result}s.
  class SearchEngineBuilder
    include HTTParty

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

    # Searches the configured search engine with the given query.
    # When adding your own search engine, you may redefine this, as long as it works with the appropriate types.
    # @param [QueryBuilder] query_builder The query builder you are searching with.
    #
    # @return [Array<Result>] An array of search results (depends on the search engine).
    # In order to map the results, use the `result_mapping` block.
    def search(query_builder)
      map_results(self.class.get(endpoint, query: query(query_builder)))
    end

    private

    # Maps the results of a response.
    # @param [HTTParty::Response] response The HTTP response from calling the defined endpoint. Should contain a `results` key you want to map.
    # @return [Array<Result>] An array of mapped results if result_mapping is defined.
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
