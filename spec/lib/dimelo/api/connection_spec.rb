require 'spec_helper'

describe Dimelo::API::Connection do

  describe '.from_uri' do

    let(:http_uri) { URI.parse('http://example.com:8080/foo/bar?egg=spam')}
    let(:https_uri) { URI.parse('https://example.com:8080/foo/bar?egg=spam')}

    it 'should infer :use_ssl => true from the scheme' do
      Dimelo::API::Connection.should_receive(:new).with('https://example.com:8080', :use_ssl => true)
      Dimelo::API::Connection.from_uri(https_uri)
    end

    it 'should infer :use_ssl => false from the scheme' do
      Dimelo::API::Connection.should_receive(:new).with('http://example.com:8080', :use_ssl => false)
      Dimelo::API::Connection.from_uri(http_uri)
    end

    it 'should support http options' do
      Dimelo::API::Connection.should_receive(:new).with('http://example.com:8080', :use_ssl => false, :timeout => 80)
      Dimelo::API::Connection.from_uri(http_uri, :timeout => 80)
    end

    it 'should reuse connections for same scheme/hosts/port' do
      first = Dimelo::API::Connection.from_uri(http_uri)
      second = Dimelo::API::Connection.from_uri(http_uri)
      first.object_id.should == second.object_id
    end

  end

  describe 'HTTP' do

    subject do
      Dimelo::API::Connection.new('www.google.fr')
    end

    let(:request) { [:get, 'http://www.google.fr/'] }

    it 'works' do
      response = subject.perform(*request)
      response.body.should_not be_nil
      response.body.should_not be_empty
      response.should be_success
    end

  end

  describe 'HTTPS' do

    subject do
      Dimelo::API::Connection.new('github.com:443', :use_ssl => true)
    end

    let(:request) { [:get, 'https://github.com/'] }

    it 'works' do
      response = subject.perform(*request)
      response.body.should_not be_nil
      response.body.should_not be_empty
      response.should be_success
    end

  end

end
