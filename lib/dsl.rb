# frozen_string_literal: true

# Config = {
#   engines: {},
# }

# This module contains the DSL for the search engine configuration.
#
# @author Shreyan Jain
# It also serves as the front object for DRb connectors. It's a big module because it has a lot of responsibilities.
module SearchEngines
  # A hash to store search engine configurations
  @engines = {}

  # Adds a search engine to the list of available engines.
  # @example Adding the Brave Search Engine's API
  #   SearchEngines.add :Brave do
  #     base_uri 'https://api.search.brave.com/'
  #     endpoint '/res/v1/web/search'
  #     format :json
  #     headers "X-Subscription-Token": ENV['BRAVE_TOKEN']
  #     query do |builder|
  #       {
  #         q: CGI.escape(builder.query),
  #         ui_lang: builder.market,
  #         safesearch: builder.safesearch ? 'strict' : 'moderate',
  #         offset: builder.offset,
  #         count: builder.count
  #       }
  #     end
  #     results 'web', 'results'
  #     result do |i|
  #       url i['url']
  #       title i['title']
  #       snippet i['description']
  #     end
  #   end
  # @example Adding the Bing Search Engine's API
  #   SearchEngines.add :Bing do
  #     base_uri 'https://api.bing.microsoft.com/'
  #     endpoint '/v7.0/search'
  #     format :json
  #     headers "Ocp-Apim-Subscription-Key": ENV['BING_API_KEY']
  #     query do |builder|
  #       {
  #         q: CGI.escape(builder.query),
  #         mkt: builder.market,
  #         SafeSearch: builder.safesearch ? 'strict' : 'moderate',
  #         offset: builder.offset,
  #         count: builder.count
  #         }
  #     end
  #     results 'webPages', 'value'
  #     result do |i|
  #       url i['url']
  #       title i['name']
  #       snippet i['snippet']
  #     end
  #   end
  # @see SearchEngineBuilder
  #
  # @param [Symbol] engine_name The name of the engine.
  # @param [Proc] block A block of code representing the search engine configuration.
  def self.add(engine_name, &block)
    engine = Class.new(SearchEngineBuilder)
    engine.tap { _1.engine_name = engine_name }.module_exec(&block)
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
  # @see SearchEngines.add
  # Please especially review the implementation of the {#search} method.
  # @author Shreyan Jain
  # @abstract
  class SearchEngineBuilder
    include HTTParty

    class << self
      # Defines an endpoint method that returns the given string.
      # This is the endpoint of your search engine's API that HTTParty will call.
      def endpoint(string)
        define_method(:endpoint) { string }
      end

      attr_accessor :engine_name

      # Defines a method that takes a block as an argument and assigns it as the implementation of the `query` method.
      #
      # Pass it a block that takes a {QueryBuilder} as an input, and returns a hash
      # which will be encoded in the URI query string as GET params.
      # @example
      #   SearchEngines.add :Bing do
      #     query do |builder|
      #       {
      #         q: CGI.escape(builder.query),
      #         mkt: builder.market,
      #         SafeSearch: builder.safesearch ? 'strict' : 'moderate',
      #         offset: builder.offset,
      #         count: builder.count
      #       }
      #     end
      #   end
      # @param block [Proc] The block to be assigned as the implementation of the `query` method.
      # @return [:query] (because it's a method definition)
      def query(&block)
        define_method(:query, &block)
      end

      def results(*result_mapping)
        define_method(:results_key) { result_mapping }
      end

      def result(&block)
        define_method(:result_mapping) { block }
      end

      def config
        OpenStruct.new(Config[:engines][engine_name.to_s].to_h)
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

    # Maps the results of a response.
    # @param [HTTParty::Response] response The HTTP response from calling the defined endpoint. Should contain a `results` key you want to map.
    # @return [Array<Result>] An array of mapped results if result_mapping is defined.
    def map_results(response)
      result_data = response.dig(*results_key)
      if result_mapping
        result_data.map { |item| map_result(item) }
      else
        raise NotImplementedError, "You must define a `result_mapping` block. Please read the docs for more info."
      end
    end

    def map_result(item)
      if result_mapping
        ResultMapper.new(item, &result_mapping).map
      else
        raise NotImplementedError, "You must define a `result_mapping` block. Please read the docs for more info."
      end
    end
  end

  # @note You will probably never directly touch this class. It is primarily used by the {SearchEngineBuilder}
  #   in order to provide syntax sugar for mapping result json (or whatever format you specified) to {Result}s.
  class ResultMapper
    def initialize(item, &block)
      @item = item
      @mapping_block = block
    end

    # A method that dynamically creates setter methods for the given keys.
    # These could use attr_writer, but this method ensures that the method will not need the = sign, since
    # that just creates unnecessary pitfalls and footguns, and just looks uglier.
    # @param keys [Array<Symbol>] The keys to create setter methods for.
    # @return [Array<Symbol>] The keys that were created.
    #
    # @note This method is used to create the syntactic sugar for `url`, `title`, and `snippet` methods to more easily map results.
    # @note `qattr` means quick attribute, fwiw
    def self.qattr(*keys)
      keys.map do |key|
        define_method(key) { |any| instance_variable_set("@#{key}", any) }
      end
    end

    # Evaluates the given block in the context of the current instance.
    # The block is expected to contain a mapping logic that assigns
    # values to instance variables, usually by using the
    # `url`, `title`, and `snippet` methods. After evaluating
    # the block, the method creates a new `Result` object with
    # the values assigned to `@url`, `@title`, and `@snippet`.
    # @note This method is not meant to be called directly.
    # @return [Result] The newly created `Result` object.
    def map
      instance_exec(@item, &@mapping_block)
      Result.new(@url, @title, @snippet)
    end

    qattr :url, :title, :snippet
  end
end
