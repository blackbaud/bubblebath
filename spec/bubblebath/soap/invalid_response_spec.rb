require 'spec_helper'

describe Bubblebath::SoapApi::SoapClient do

  describe 'invalid responses' do

    it 'should raise a fault with the http status code of 404 regardless of the body of the response' do
      stub_response_body = <<eos
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
   <soap:Body>
      <SayHelloResponse>
          <SayHelloResult>the body should not matter at all</SayHelloResult>
      </SayHelloResponse>
   </soap:Body>
</soap:Envelope>
eos
      stub_request(:post, 'http://localhost:8000/').to_return(body: stub_response_body, :status => 404, :headers => { 'Content-Length' => 4 })
      expect {SayHello.new(id: 123, type: 222, flag: true, notes: 'some notes').result}.to raise_exception("HTTP STATUS: '404', MESSAGE: ' '")
    end

    it 'should raise an error with the message and status code when response status is anything less that 200 or greater than 299' do
      stub_response_body = <<eos
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
   <soap:Body>
      <SayHelloResponse>
          <SayHelloResult>the result node 123</SayHelloResult>
      </SayHelloResponse>
   </soap:Body>
</soap:Envelope>
eos
      stub_request(:post, 'http://localhost:8000/').to_return(body: stub_response_body, :status => 100, :headers => { 'Content-Length' => 3 })
      expect {SayHello.new(id: 123, type: 222, flag: true, notes: 'some notes').result}.to raise_exception("HTTP STATUS: '100', MESSAGE: ' '")

      stub_request(:post, 'http://localhost:8000/').to_return(body: stub_response_body, :status => 199, :headers => { 'Content-Length' => 3 })
      expect {SayHello.new(id: 123, type: 222, flag: true, notes: 'some notes').result}.to raise_exception("HTTP STATUS: '199', MESSAGE: ' '")

      stub_request(:post, 'http://localhost:8000/').to_return(body: stub_response_body, :status => 300, :headers => { 'Content-Length' => 3 })
      expect {SayHello.new(id: 123, type: 222, flag: true, notes: 'some notes').result}.to raise_exception("HTTP STATUS: '300', MESSAGE: ' '")

      stub_request(:post, 'http://localhost:8000/').to_return(body: stub_response_body, :status => 500, :headers => { 'Content-Length' => 3 })
      expect {SayHello.new(id: 123, type: 222, flag: true, notes: 'some notes').result}.to raise_exception("HTTP STATUS: '500', MESSAGE: ' '")
    end

    it 'should not raise an exception for a null response' do
      stub_response_body = <<eos
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
   <soap:Body>
      <SayHelloResponse>
      </SayHelloResponse>
   </soap:Body>
</soap:Envelope>
eos
      stub_request(:post, 'http://localhost:8000/').to_return(:status => 200, :body => stub_response_body, :headers => {})
      expect {SayHello.new(id: 123, type: 222, flag: true, notes: 'some notes').result}.to_not raise_exception("HTTP STATUS: '200', MESSAGE: 'RESPONSE HAS NO CONTENT'")
    end
  end
end