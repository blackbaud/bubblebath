require 'spec_helper'

ENV['JAVA_HOME'] = '/Library/Java/Home'

describe Bubblebath::SoapApi::SoapClient do

  describe 'parent client' do
    it 'should return assigned wsdl' do
      MySoapClient.new.wsdl.should include('say_hello_wsdl.xml')
    end

    it 'should return list of supported operations defined in wsdl' do
      MySoapClient.new.operations.should == %w(SayHello Ping PurchaseItem)
    end
  end

  describe 'SayHello operation' do
    it 'should return list of supported operations defined in wsdl' do
      SayHello.new.operations.should == %w(SayHello Ping PurchaseItem)
    end

    it 'should return example request body' do
      SayHello.new.example_body.should == {:SayHello=>{:Id=>"integer", :Type=>"integer", :Flag=>"boolean", :Notes=>"string"}}
    end

    it 'should return example header' do
      SayHello.new.example_header.should == {}
    end

    it 'should return options' do
      SayHello.new(id: 123, type: 222, flag: true, notes: 'some notes').options.should == {:id=>123, :type=>222, :flag=>true, :notes=>"some notes"}
    end

    it 'should return result when using body()' do
      stub_response_body = <<eos
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
   <soap:Body>
      <SayHelloResponse>
          <SayHelloResult>the result node 123</SayHelloResult>
      </SayHelloResponse>
   </soap:Body>
</soap:Envelope>
eos

      stub_request(:post, 'http://localhost:8000/').to_return(body: stub_response_body, :status => 200, :headers => { 'Content-Length' => 3 })
      SayHello.new(id: 123, type: 222, flag: true, notes: 'some notes').result.should == 'the result node 123'
    end

    it 'should return wsdl diff' do
      wsdl1 = 'spec/support/wsdl/say_hello_wsdl.xml'
      wsdl2 = 'spec/support/wsdl/say_hello_wsdl2.xml'
      Bubblebath::SoapApi::SoapClient.new.wsdl_diff(wsdl1, wsdl2).to_s.should include 'SayGoodbye'
    end

  end

  describe 'PurchaseItem operation' do
    it 'should return example request body' do
      PurchaseItem.new.example_body.should == {:PurchaseItem=>{:Id=>"integer", :Quantity=>"integer"}}
    end

    it 'should result when using xml_envelope()' do
      stub_response_body = <<eos
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
   <soap:Body>
      <PurchaseItemResponse>
          <PurchaseItemResult>purchased 5 of item '1234'</PurchaseItemResult>
      </PurchaseItemResponse>
   </soap:Body>
</soap:Envelope>
eos

      stub_request(:post, 'http://localhost:8000/').to_return(body: stub_response_body, :status => 200, :headers => { 'Content-Length' => 3 })
      PurchaseItem.new(id: '1234', quantity: 5).result.should == "purchased 5 of item '1234'"
    end

  end

end