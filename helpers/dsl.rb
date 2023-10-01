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
    attr_accessor :url_block, :results_block, :headers_block
    class << self
      def endpoint(string)
        define_method(:endpoint) { string }
      end

      def query(&block)
        define_method(:query, &block)
      end

      def results(&block)
        define_method(:results, &block)
      end

      # def request_headers(&hash)
      #   @@headers = hash.call
      # end
    end

    def search(query_builder)
      results(self.class.get(endpoint, query: query(query_builder)))
    end
  end
end
