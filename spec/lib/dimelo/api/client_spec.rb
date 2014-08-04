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
                  }},
            status: status
  end
  describe '#transport' do

    it 'return an the response body' do
      json = JSON.parse(subject.transport(:get, 'check'))
      expect(json).to eq({"success" => true})
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
      allow(subject).to receive_message_chain('connection.perform') { response_error 403, 'api_not_enabled' }
      expect{
        subject.transport(:get, 'check', {'access_token' => 'my-token'})
      }.to raise_error(Dimelo::API::NotEnabledError)
    end

    it 'raise SSLError if request should be https' do
      allow(subject).to receive_message_chain('connection.perform') { response_error 412, 'routing_error' }
      expect{
        subject.transport(:get, 'check', {'access_token' => 'my-token'})
      }.to raise_error(Dimelo::API::SslError)
    end

    it 'raise InvalidUserTypeError if create user is invalid' do
      allow(subject).to receive_message_chain('connection.perform') { response_error 400, 'invalid_user_type' }
      expect{
        subject.transport(:post, '/users', {'access_token' => 'my-token'})
      }.to raise_error(Dimelo::API::InvalidUserTypeError)
    end

    it 'raise DomainNotFoundError if request on invalid domain' do
      client = Dimelo::API::Client.new('https://no-domain.api.users.dimelo.info:4433/1.0', 'access_token' => ::ACCESS_TOKEN, :http_options => {:timeout => 80})
      expect{
        client.transport(:get, '/check', {'access_token' => 'my-token'})
      }.to raise_error(Dimelo::API::DomainNotFoundError)
    end

    it 'raise an API::Error if body is not json' do
      allow(subject).to receive_message_chain('connection.perform') { double success?: false, body: 'MemCache Error', status: 500 }
      expect{
        subject.transport(:post, '/users', {'access_token' => 'my-token'})
      }.to raise_error(Dimelo::API::Error, 'POST /users - 500 MemCache Error')
    end

    it 'raise an API::BaseError if error does not match defined errors' do
      allow(subject).to receive_message_chain('connection.perform') { response_error 123, 'unable_action', 'cannot perform action' }
      expect{
        subject.transport(:post, '/users', {'access_token' => 'my-token'})
      }.to raise_error(Dimelo::API::BaseError, 'error_type:unable_action - status:123 - body:cannot perform action')
    end

  end

  describe '#default_parameters' do
    it 'is not polluted by http_options' do
      expect(subject.default_parameters).not_to include('http_options')
      expect(subject.default_parameters).not_to include(:http_options)
    end
  end

  describe '#connection' do

    it 'returns a Connection' do
      expect(subject.send(:connection)).to be_kind_of(Dimelo::API::Connection)
    end

    it 'supports http_options' do
      expect(Dimelo::API::Connection).to receive(:from_uri).with(anything,hash_including(:timeout => 80))
      subject.send(:connection)
    end
  end
end
