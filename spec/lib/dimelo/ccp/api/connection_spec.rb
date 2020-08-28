require 'spec_helper'

describe Dimelo::CCP::API::Connection do

  describe '.from_uri' do

    let(:http_uri) { URI.parse('http://example.com:8080/foo/bar?egg=spam')}
    let(:https_uri) { URI.parse('https://example.com:8080/foo/bar?egg=spam')}

    it 'should infer :use_ssl => true from the scheme' do
      expect(Dimelo::CCP::API::Connection).to receive(:new).with('https://example.com:8080/foo/bar?egg=spam', :use_ssl => true)
      Dimelo::CCP::API::Connection.from_uri(https_uri)
    end

    it 'should infer :use_ssl => false from the scheme' do
      expect(Dimelo::CCP::API::Connection).to receive(:new).with('http://example.com:8080/foo/bar?egg=spam', :use_ssl => false)
      Dimelo::CCP::API::Connection.from_uri(http_uri)
    end

    it 'should support http options' do
      expect(Dimelo::CCP::API::Connection).to receive(:new).with('http://example.com:8080/foo/bar?egg=spam', :use_ssl => false, :timeout => 80)
      Dimelo::CCP::API::Connection.from_uri(http_uri, :timeout => 80)
    end

    it 'should reuse connections for same scheme/hosts/port' do
      first = Dimelo::CCP::API::Connection.from_uri(http_uri)
      second = Dimelo::CCP::API::Connection.from_uri(http_uri)
      expect(first.object_id).to eq(second.object_id)
    end

  end

  describe '#perform' do

    context 'HTTP' do

      subject do
        Dimelo::CCP::API::Connection.new('http://www.google.fr')
      end

      let(:request) { [:get, 'http://www.google.fr/'] }

      it 'works' do
        response = subject.perform(*request)
        expect(response.body).to_not be_empty
        expect(response).to be_success
      end

    end

    context 'HTTPS' do

      subject do
        Dimelo::CCP::API::Connection.new('www.google.fr:443', :use_ssl => true)
      end

      let(:request) { [:get, 'https://www.google.fr/'] }

      it 'works' do
        response = subject.perform(*request)
        expect(response.body).to_not be_empty
        expect(response).to be_success
      end

    end

    subject do
      Dimelo::CCP::API::Connection.new('github.com:443')
    end

    let(:file) { Faraday::UploadIO.new(File.expand_path('../../../../../fixtures/files/logo.jpg', __FILE__), 'image/jpeg') }

    it 'sends multipart request with attachment' do
      response = subject.perform(:put, 'http://www.google.com', {:file => file})
      expect(response.env[:request_headers]["Content-Type"]).to include('multipart/form-data')
    end

    it 'sends multipart when containing attachment param' do
      response = subject.perform(:put, 'http://www.google.com', {:file => file, :q => 'hello'})
      expect(response.env[:request_headers]["Content-Type"]).to include('multipart/form-data')
    end

    it 'should sends form urlencoded without attachment' do
      response = subject.perform(:put, 'http://www.google.com', {:q => 'hello'})
      expect(response.env[:request_headers]["Content-Type"]).to eq('application/x-www-form-urlencoded')
    end

    it 'sends accept json request' do
      response = subject.perform(:get, 'http://www.google.com', {:q => 'hello'})
      expect(response.env[:request_headers][:accept]).to eq('application/json')
      expect(response).to be_success
    end

    it 'sends user_agent request' do
      response = subject.perform(:get, 'http://www.google.com', {:q => 'hello'})
      expect(response.env[:request_headers][:user_agent]).to eq("DimeloAPI/#{Dimelo::CCP::API::VERSION} Faraday/#{Faraday::VERSION} Ruby/#{RUBY_VERSION}")
      expect(response).to be_success
    end

    it 'sends access_token in authorization header' do
      response = subject.perform(:get, 'http://www.google.com', { q: 'hello', access_token: 'token' })
      expect(response.env[:request_headers][:authorization]).to eq("Bearer token")
      expect(response).to be_success
    end

    it 'does not send access_token in payload' do
      response = subject.perform(:get, 'http://www.google.com', { q: 'hello', access_token: 'token' })
      expect_any_instance_of(Faraday::Connection).to receive(:get)#.with(:get, 'http://www.google.com', q: 'hello')
      expect(response).to be_success
    end

    context 'Custom user_agent with valid ASCII characters' do
      let!(:custom_user_agent) { "SMCC; I asked and failed" }

      subject do
        Dimelo::CCP::API::Connection.new('github.com:443', :user_agent => custom_user_agent)
      end

      it 'sends custom user_agent request' do
        response = subject.perform(:get, 'http://www.google.com', {:q => 'hello'})
        expect(response.env[:request_headers][:user_agent]).to eq("DimeloAPI/#{Dimelo::CCP::API::VERSION} (#{custom_user_agent}) Faraday/#{Faraday::VERSION} Ruby/#{RUBY_VERSION}")
        expect(response).to be_success
      end
    end

    context 'Custom user_agent with invalid UTF-8 characters' do
      let!(:custom_user_agent) { "SMCC; J'ai demandé & j'ai échoué" }

      subject do
        Dimelo::CCP::API::Connection.new('github.com:443', :user_agent => custom_user_agent)
      end

      it 'sends custom user_agent request' do
        response = subject.perform(:get, 'http://www.google.com', {:q => 'hello'})
        expect(response.env[:request_headers][:user_agent]).to eq("DimeloAPI/#{Dimelo::CCP::API::VERSION} (SMCC; J'ai demand & j'ai chou) Faraday/#{Faraday::VERSION} Ruby/#{RUBY_VERSION}")
        expect(response).to be_success
      end
    end
  end

end
