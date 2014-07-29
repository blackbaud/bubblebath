
class Savon
  class HTTPClient
    attr_reader :http_response
    def post(url, headers, body)
      request(:post, url, headers, body)
    end

    private

    def request(method, url, headers, body)
      response = @client.request(method, url, nil, body, headers)
      @http_response = response
      response.content
    end

  end
end
