require 'spec_helper'

describe Dimelo::API::Client do

  subject do
    Dimelo::API::Client.new('https://domain-test.api.users.dimelo.info:4433/1.0', 'access_token' => ::ACCESS_TOKEN, :http_options => {:timeout => 80})
  end

  def response_error(status, error, message='')
    double  success?: false,
            body: %Q{{
                    "error": "#{error}",
                    "message": "#{message}",
                    "status": #{status}
                  }}
  end
  describe '#transport' do

    it 'return an the response body' do
      json = JSON.parse(subject.transport(:get, 'check'))
      json.should == {"success" => true}
    end

    it 'raise InvalidAccessTokenError if token is invalid' do
      expect{
        subject.transport(:get, 'check', {'access_token' => 'invalid'})
      }.to raise_error(Dimelo::API::InvalidAccessTokenError)
    end

    it 'raise NotFoundError if path is invalid' do
      expect{
        subject.transport(:get, 'invalid_path', {'access_token' => 'invalid'})
      }.to raise_error(Dimelo::API::NotFoundError)
    end

    it 'raise NotEnabledError if api is not enabled' do
      subject.stub_chain(:connection, :perform) { response_error 403, 'api_not_enabled' }
      expect{
        subject.transport(:get, 'check', {'access_token' => 'my-token'})
      }.to raise_error(Dimelo::API::NotEnabledError)
    end

    it 'raise SSLError if request should be https' do
      subject.stub_chain(:connection, :perform) { response_error 412, 'routing_error' }
      expect{
        subject.transport(:get, 'check', {'access_token' => 'my-token'})
      }.to raise_error(Dimelo::API::SslError)
    end

    it 'raise InvalidUserTypeError if create user is invalid' do
      subject.stub_chain(:connection, :perform) { response_error 400, 'invalid_user_type' }
      expect{
        subject.transport(:post, '/users', {'access_token' => 'my-token'})
      }.to raise_error(Dimelo::API::InvalidUserTypeError)
    end

    it 'raise DomainNotFoundError if request on invalid domain' do
      pending 'wait for ccp to handle domain not found as 404'
      client = Dimelo::API::Client.new('https://no-domain.api.users.dimelo.info:4433/1.0', 'access_token' => ::ACCESS_TOKEN, :http_options => {:timeout => 80})
      expect{
        client.transport(:get, '/check', {'access_token' => 'my-token'})
      }.to raise_error(Dimelo::API::DomainNotFoundError)
    end

    it 'raise an API::Error if body is not json' do
      subject.stub_chain(:connection, :perform) { double success?: false, body: 'MemCache Error' }
      expect{
        subject.transport(:post, '/users', {'access_token' => 'my-token'})
      }.to raise_error(Dimelo::API::Error, 'MemCache Error')
    end

    it 'raise an API::BaseError if error does not match defined errors' do
      subject.stub_chain(:connection, :perform) { response_error 123, 'unable_action', 'cannot perform action' }
      expect{
        subject.transport(:post, '/users', {'access_token' => 'my-token'})
      }.to raise_error(Dimelo::API::BaseError, 'cannot perform action')
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
