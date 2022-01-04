require 'spec_helper'

describe Dimelo::CCP::API::Client do

  subject do
    Dimelo::CCP::API::Client.new('https://domain-test.api.users.dimelo.com/1.0', 'access_token' => ENV['DIMELO_API_KEY'], :http_options => {:timeout => 80})
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
      pending('no api key') unless ENV['DIMELO_API_KEY'].present?
      json = JSON.parse(subject.transport(:get, 'check'))
      expect(json).to eq({"success" => true})
    end

    it 'raise InvalidAccessTokenError if token is invalid' do
      expect{
        subject.transport(:get, 'check', {'access_token' => 'invalid'})
      }.to raise_error(Dimelo::CCP::API::InvalidAccessTokenError)
    end

    it 'raise NotFoundError if path is invalid' do
      expect{
        subject.transport(:get, 'invalid_path', {'access_token' => 'invalid'})
      }.to raise_error(Dimelo::CCP::API::NotFoundError)
    end

    it 'raise NotEnabledError if api is not enabled' do
      allow(subject).to receive_message_chain('connection.perform') { response_error 403, 'api_not_enabled' }
      expect{
        subject.transport(:get, 'check', {'access_token' => 'my-token'})
      }.to raise_error(Dimelo::CCP::API::NotEnabledError)
    end

    it 'raise SSLError if request should be https' do
      allow(subject).to receive_message_chain('connection.perform') { response_error 412, 'routing_error' }
      expect{
        subject.transport(:get, 'check', {'access_token' => 'my-token'})
      }.to raise_error(Dimelo::CCP::API::SslError)
    end

    it 'raise InvalidUserTypeError if create user is invalid' do
      allow(subject).to receive_message_chain('connection.perform') { response_error 400, 'invalid_user_type' }
      expect{
        subject.transport(:post, 'users', {'access_token' => 'my-token'})
      }.to raise_error(Dimelo::CCP::API::InvalidUserTypeError)
    end

    it 'raise DomainNotFoundError if request on invalid domain' do
      client = Dimelo::CCP::API::Client.new('https://no-domain.api.users.dimelo.com/1.0', :http_options => {:timeout => 80})
      expect{
        client.transport(:get, 'check', {'access_token' => 'my-token'})
      }.to raise_error(Dimelo::CCP::API::DomainNotFoundError)
    end

    it 'raise an API::Error if body is not json' do
      allow(subject).to receive_message_chain('connection.perform') { double success?: false, body: 'MemCache Error', status: 500 }
      expect{
        subject.transport(:post, 'users', {'access_token' => 'my-token'})
      }.to raise_error(Dimelo::CCP::API::Error, 'POST users - 500 MemCache Error')
    end

    it 'raise an API::BaseError if error does not match defined errors' do
      allow(subject).to receive_message_chain('connection.perform') { response_error 123, 'unable_action', 'cannot perform action' }
      expect{
        subject.transport(:post, 'users', {'access_token' => 'my-token'})
      }.to raise_error(Dimelo::CCP::API::BaseError, 'error_type:unable_action - status:123 - body:cannot perform action')
    end

    it 'return an the response body in case of validation error' do
      pending('no api key') unless ENV['DIMELO_API_KEY'].present?
      json = JSON.parse(subject.transport(:post, 'roles', {}))
      expect(json).to include "error" => 'validation_error'
      expect(json).to include "errors" => [{"attribute"=>"label", "type"=>"invalid", "message"=>"Label is invalid"}]
      expect(json).to include "message" => "Role can't be saved"
      expect(json).to include "status" => 422
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
      expect(subject.send(:connection)).to be_kind_of(Dimelo::CCP::API::Connection)
    end

    it 'supports http_options' do
      expect(Dimelo::CCP::API::Connection).to receive(:from_uri).with(anything,hash_including(:timeout => 80))
      subject.send(:connection)
    end
  end

end
