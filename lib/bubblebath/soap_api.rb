require 'savon'
require 'soapui-util'
require 'bubblebath/exceptions'
require 'bubblebath/configuration'

module Bubblebath
  module SoapApi

    class SoapClient
      attr_accessor :local_wsdl, :wsdl, :options, :soap_schema_compliance, :service, :port,
                    :cookie, :stored_cookie, :header, :http_headers,
                    :basic_auth_domain, :basic_auth_username, :basic_auth_password
      attr_reader :client, :operation, :response

      @@session_cookie = nil

      include Utilities

      def initialize(options = {})
        @wsdl ||= wsdl
        @options ||= options
        @soap_schema_compliance = Bubblebath::Configuration.instance.soap_schema_compliance
        @verify_ssl = verify_ssl?
        @cookie = cookie
        if @soap_schema_compliance.nil?
          @soap_schema_compliance = true
        end

        @service ||= service
        @port ||= port

        log.debug("DEBUG: wsdl: #{@wsdl}")
        log.debug("DEBUG: request options: #{@options.inspect}")
      end

      def client
        @client ||= create_client
      end

      def services
        client.services
      end

      def operations
        client.operations(@service, @port)
      end

      def example_body
        operation.example_body
      end

      def example_header
        operation.example_header
      end

      def stored_cookie
        @@session_cookie
      end

      def fault_exists?
        request if @response.nil?
        log.debug("DEBUG: SOAP request: #{@response.body}")
        @response.body.has_key?(:fault) ? true : false
      end

      def fault_message
        request if @response.nil?
        log.debug("DEBUG: SOAP request.body: #{@response.body}")
        fault_exists? ? @response.body[:fault][:faultstring] : nil
      end

      def validate_response
        nil_response = 'RESPONSE HAS NO CONTENT'
        status_code = @http_client.http_response.code

        if fault_exists?
          log.warn ("HTTP STATUS: '#{status_code}', MESSAGE: '#{fault_message}'")
        elsif status_code.between?(200, 299) and @response.body.values[0].nil?
          log.warn("HTTP STATUS: '#{status_code}', MESSAGE: '#{nil_response}'")
        elsif status_code.between?(200, 299)
          # DO NOTHING
          log.debug("HTTP STATUS: '#{status_code}', MESSAGE: '#{nil_response}'")
        else
          raise "HTTP STATUS: '#{status_code}', MESSAGE: ' #{@http_client.http_response.reason}'"
        end

        @response
      end

      protected

      def request
        @response.nil? ? run : validate_response
      end

      def run
        log.debug("DEBUG: operation soap header: #{operation.header}")

        # use <Operation>.xml_envelope over <Operation>.body
        if respond_to?(:xml_envelope)
          operation.xml_envelope = xml_envelope
        else
          operation.body = body
        end

        # make operation request and store response
        @response = operation.call

        if @soap_schema_compliance
          results = SoapuiUtil.validate_schema_compliance(@response.raw, @wsdl)
          raise ::Bubblebath::SchemaComplianceError.new(results) if results.length > 0
        end
        log.debug("DEBUG: raw @response: #{@response.inspect}")
        validate_response
      end

      def operation
        @operation ||= create_operation(@service, @port, operation_name_as_symbol)
      end

      private

      def create_client
        savon_http_client = create_http_client
        savon_http_client.client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE unless @verify_ssl
        #savon_http_client.client.ssl_config.ssl_version = :TLSv1_1
        savon_http_client.client.ssl_config.add_trust_ca(local_ssl_ca_file) unless local_ssl_ca_file == nil
        savon_http_client.client.set_auth(basic_auth_domain, basic_auth_username, basic_auth_password)

        if @@session_cookie != nil and @@session_cookie != []
          log.debug("Cookie is being passed in with the request #{@@session_cookie}")
          savon_http_client.client.cookie_manager.cookies = @@session_cookie
        end

        log.debug("DEBUG: cookie present in create_client call: #{savon_http_client.client.cookies}")

        Savon.new(@wsdl, savon_http_client)
      end

      def create_operation(service, port, operation=nil)
        c = client
        @cookie = c.http.cookies

        c.operation(service, port, operation)
      end

      def operation_name_as_symbol
        self.class.name.demodulize.to_sym
      end

      def create_http_client
        @http_client = Savon::HTTPClient.new
      end

    end

  end
end