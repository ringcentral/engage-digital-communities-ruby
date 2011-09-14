require 'spec_helper'

describe Dimelo::API::Client do
  
  subject do
    Dimelo::API::Client.new('https://domain-test.api.users.dimelo.com/1.0', 'access_token' => ::ACCESS_TOKEN, :http_options => {:timeout => 80})
  end
  
  describe '#request' do
  
    def request(options)
      subject.request(
        options[:method] || :get,
        options[:path] ||'/check',
        options[:params] || {}
      )
    end
  
    it 'take care of the verb' do
      request(:method => :get).should be_a(Net::HTTP::Get)
      request(:method => :post).should be_a(Net::HTTP::Post)
      request(:method => :put).should be_a(Net::HTTP::Put)
      request(:method => :delete).should be_a(Net::HTTP::Delete)
    end
  
    it 'join the path' do
      req = request(:path => '/check')
      uri = URI.parse(req.path)
      uri.path.should == '/1.0/check'
    end
  
    it 'merge query' do
      req = request(:params => {:query => {:foo => 42}})
      uri = URI.parse(req.path)
      params = CGI.parse(uri.query)
      params.should == {'foo' => %w(42), 'access_token' => [::ACCESS_TOKEN] }
    end
    
    it 'provide body' do
      req = request(:verb => :post, :params => {:body => 'Hello World !'})
      req.body.should == 'Hello World !'
    end
    
  end
  
  describe '#transport' do
    
    it 'return an the response body' do
      subject.transport(:get, '/check').should == %Q({\n  "success": true\n})
    end
    
    it 'raise if response is not a 2XX' do
      expect{
        subject.transport(:get, '/check', {:query => {'access_token' => 'invalid'}})
      }.to raise_error(Dimelo::API::Error)
    end
    
  end
  
  describe '#default_parameters' do
    it 'is not polluted by http_options' do
      subject.default_parameters.should_not include('http_options')
      subject.default_parameters.should_not include(:http_options)
    end
  end

  describe '#connection' do

    it 'returns a Connection' do
      subject.send(:connection).should be_kind_of(Dimelo::API::Connection)
    end

    it 'supports http_options' do
      Dimelo::API::Connection.should_receive(:from_uri).with(anything,hash_including(:timeout => 80))
      subject.send(:connection)
    end
  end
end
