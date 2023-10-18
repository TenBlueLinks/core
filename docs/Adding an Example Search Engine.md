# TenBlueLinks - Extending with Your Own Search Engine

If you want to add your own search engine to TenBlueLinks, this guide will walk you through the process. In this example, we will focus on integrating the Bing search engine.

## Prerequisites

Before you begin, make sure you have the following prerequisites:

- **Ruby**: TenBlueLinks is a Ruby-based project, so ensure you have Ruby installed on your system.

- **TenBlueLinks Core**: Obviously.


## Getting Started

To add your own search engine to TenBlueLinks, follow these steps:

1. **Clone the TenBlueLinks Repository**: If you haven't already, clone the TenBlueLinks repository to your local machine.

2. **Access the SearchEngines Module**:

In the repository, navigate to the `search_engines` dir in the `lib` directory.
This directory contains the SearchEngines module where you can define your search engine configuration.

3. **Define Your Search Engine Configuration**:

Create the `bing.rb` file, where you can define your search engine's configuration using the `SearchEngines.add` method. The following is an example of adding the Bing search engine:
  ```ruby
  SearchEngines.add :Bing do
    base_uri 'https://api.bing.microsoft.com/'
    endpoint '/v7.0/search'
    format :json
    headers "Ocp-Apim-Subscription-Key": ENV['BING_API_KEY']
    query do |builder|
      {
        q: CGI.escape(builder.query),
        mkt: builder.market,
        SafeSearch: builder.safesearch ? 'strict' : 'moderate',
        offset: builder.offset,
        count: builder.count
      }
    end
    results 'webPages', 'value'
    result do |i|
      url i['url']
      title i['name']
      snippet i['snippet']
    end
  end
  ```
Here's a breakdown of the key configuration options:


- `base_uri`: The base URL for the search engine's API.

- `endpoint`: The endpoint path for the search.
- `format`: The format in which results are expected (e.g., JSON).
- `headers`: HTTP headers to be included in requests.
- `query`: A block that specifies the query parameters to be included in the request.
- `results`: Defines how to extract results from the API response.
- `result`: A block that maps individual search results from the API response.

Most of these methods are explained in depth in the documentation for {SearchEngines::SearchEngineBuilder}.

Customize the configuration according to your search engine's API specifications.

4. **Add API Key**:

Make sure you have the necessary API keys or authentication credentials. In the example above, the Bing API key is stored in the `ENV['BING_API_KEY']` variable. Ensure you set the API key in your environment variables.

5. **Testing Your Configuration**:

You can test your search engine configuration by running the TenBlueLinks application with the following commands in IRB:

```ruby
require "./lib/service.rb"
query = QueryBuilder.new("Hello World!", "en_US", true, 0, 10)
SearchEngines.search_with(:Bing, query) #=> [Result(url, title, snippet)]
```

You can then use TenBlueLinks to search with your newly added search engine.

Congratulations! You've successfully added your own search engine to TenBlueLinks. You can now use TenBlueLinks to search with your newly integrated search engine alongside other supported engines.

Happy searching!
