require 'httparty'

module Bubblebath
  module RestApi

    class HParty
      include HTTParty
      extend Utilities

      ssl_ca_file(local_ssl_ca_file)
    end

    class RestClient
      include Utilities

      def base_uri(uri)
        HParty.base_uri(uri)
      end

      def post(url, options)
        HParty.post(url, options)
      end

      def get(url, options)
        HParty.get(url, options)
      end

    end

  end
end