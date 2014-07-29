require 'simplecov'
require 'coveralls'

#Coveralls.wear!
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter 'spec'
end

require 'support/my_soap_client'
require 'support/my_rest_client'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

include SayHeyServices
include MyTestService::SoapApi
include MyTestService::SoapApi::HelloPoint
include MyTestService::RestApi
