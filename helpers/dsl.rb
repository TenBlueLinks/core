module SearchEngines
  # A hash to store search engine configurations
  @engines = {}

  def self.add(engine_name, &block)
    engine = SearchEngineBuilder.new
    engine.instance_eval(&block)
    @engines[engine_name.downcase.to_sym] = [engine_name, engine.method(:search).to_proc]
  end

  def self.engines
    @engines
  end

  class SearchEngineBuilder
    attr_accessor :url_block, :results_block, :headers_block

    def initialize
      @url_block = nil
      @results_block = nil
      @headers_block = nil
    end

    def url(&block)
      @url_block = block
    end

    def results(&block)
      @results_block = block
    end

    def headers(&block)
      @headers_block = block
    end

    def search(query)
      @results_block.(JSON.parse(HTTParty.get(@url_block.(query), headers: @headers_block.()).body))
    end
  end
end
