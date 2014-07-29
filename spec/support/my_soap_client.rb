require 'bubblebath'

module MyTestService
  module SoapApi

    class MySoapClient < Bubblebath::SoapApi::SoapClient
      def local_wsdl
        wsdl_name = 'wsdl/say_hello_wsdl.xml'
        File.expand_path(wsdl_name, File.dirname(__FILE__))
      end

      def wsdl
        @wsdl = local_wsdl
      end

      def service
        @service = :HelloWorldService
      end

      def port
        @port = :Application
      end
    end

  end
end

module MyTestService
  module SoapApi
    module HelloPoint

      class SayHello < MySoapClient
        attr_accessor :id, :type, :flag, :notes, :result

        def initialize(options=nil)
          super
          wsdl
          @id ||= options[:id] unless options == nil
          @type ||= options[:type] unless options == nil
          @flag ||= options[:flag] unless options == nil
          @notes ||= options[:notes] unless options == nil
        end

        def body
          { SayHelloRequest: { Id: id, Type: type, Flag: flag, Notes: notes } }
        end

        def request
          super
        end

        def result
          log.debug("----DEBUG - this is the returned result: #{request.inspect}")
          request.body[:say_hello_response][:say_hello_result]
        end
      end

      class PurchaseItem < MySoapClient
        attr_accessor :id

        def initialize(options=nil)
          super
          @id ||= options[:id] unless options == nil
        end

        def xml_envelope
          '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/" xmlns:tns="http://schemas.xmlsoap.org/wsdl/" xmlns:types="http://schemas.xmlsoap.org/wsdl/encodedTypes" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
            <soap:Body soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
              <PurchaseItem>
                <id>'+@id+'</id>
              </PurchaseItem>
            </soap:Body>
          </soap:Envelope>'
        end

        def request
          super
        end

        def result
          request.body[:purchase_item_response][:purchase_item_result]
        end
      end

    end
  end
end


module SayHeyServices

  class SayHeyClient < Bubblebath::SoapApi::SoapClient
    def local_wsdl
      wsdl_name = 'wsdl/say_hello_wsdl.xml'   #'wsdl/basic_auth_wsdl.xml'
      File.expand_path(wsdl_name, File.dirname(__FILE__))
    end

    def wsdl
      @wsdl = local_wsdl
    end

    def basic_auth_username
      @basic_auth_username = Bubblebath::Configuration.instance.basic_auth_username
    end

    def basic_auth_password
      @basic_auth_password = Bubblebath::Configuration.instance.basic_auth_password
    end

    def service
      @service = :HelloWorldService
    end

    def port
      @port = :Application
    end
  end

  class Ping < SayHeyClient
    def initialize(client_id, options=nil)
      wsdl
      @client_id = client_id
      @operation = client.operation(service, port, :Ping)
      @operation.body = body
    end

    def body
      {:PingRequest =>
           {:ClientAppInfo =>
                {ClientAppLicenseID: @client_id,
                 _REDatabaseToUse: "EXAMPLE"},
            MessageToEcho: @message_to_echo,
            ConnectToDatabase: @connect_to_database,}
      }
    end

    def result
      request = @operation.call
      request.body
    end
  end

end

