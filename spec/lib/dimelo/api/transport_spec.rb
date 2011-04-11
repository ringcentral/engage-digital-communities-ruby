require 'spec_helper'

describe Dimelo::API::Transport do
  
  subject do
    Dimelo::API::Transport.new('https://domain-test.users.dimelo.com/api/1.0', 'access_token' => 'b8d969f01114a7f40fb25ae30348bb37')
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
      uri.path.should == '/api/1.0/check'
    end
  
    it 'merge query' do
      req = request(:params => {:query => {:foo => 42}})
      uri = URI.parse(req.path)
      params = CGI.parse(uri.query)
      params.should == {'foo' => %w(42), 'access_token' => %w(b8d969f01114a7f40fb25ae30348bb37)}
    end
    
    it 'provide body' do
      req = request(:verb => :post, :params => {:body => 'Hello World !'})
      req.body.should == 'Hello World !'
    end
    
  end
  
  describe '#transport' do
    
    it 'return an HTTPResponse' do
      subject.transport(:get, '/check').should be_a(Net::HTTPResponse)
    end
    
  end
  
end
