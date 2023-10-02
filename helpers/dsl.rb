module SearchEngines
  # A hash to store search engine configurations
  @engines = {}

  def self.add(engine_name, &block)
    engine = Class.new(SearchEngineBuilder)
    engine.module_exec(&block)
    @engines[engine_name.downcase.to_sym] = [engine_name, engine.new.method(:search).to_proc]
  end

  def self.engines
    @engines
  end

  class SearchEngineBuilder
    include HTTParty
    attr_accessor :url_block, :results_block, :headers_block, :result_mapping

    class << self
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

    def search(query_builder)
      map_results(self.class.get(endpoint, query: query(query_builder)))
    end

    private

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
