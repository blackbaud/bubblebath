require 'spec_helper'

# input your credentials and endpoint in the config.yml file
describe Bubblebath::SoapApi::SoapClient do

  it 'should ping and authenticate successfully' do
    input_hash = {
        message_to_echo: "test",
    }

    stub_response_body = <<eos
<soap:Envelope >
   <soap:Body>
      <Response>
          <Result>Successful Authentication</Result>
      </Response>
   </soap:Body>
</soap:Envelope>
eos
    # username and password are needed for Webmock/stubbing
    username = "user"
    password = "passwd"
    auth_cred = Base64.encode64("#{username}:#{password}").strip

    stub_request(:post, "http://#{username}:#{password}@localhost:8000").
        with(:headers => {'Authorization'=>"Basic #{auth_cred}"}).
        to_return(body: stub_response_body, :status => 200, :headers => {})

    client_id = "0000000000"

    result = Ping.new(client_id, input_hash).result

  end

end