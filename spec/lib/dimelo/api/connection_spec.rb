require 'spec_helper'

describe Dimelo::API::Connection do
  
  describe 'HTTP' do
  
    subject do
      Dimelo::API::Connection.new('www.google.fr', 80)
    end
  
    let(:request) { Net::HTTP::Get.new('http://www.google.fr/') }
  
    it 'works' do
      response = subject.perform(request)
      response.body.should_not be_nil
      response.body.should_not be_empty
      response.should be_a(Net::HTTPSuccess)
    end
    
  end
  
  describe 'HTTPS' do
    
    subject do
      Dimelo::API::Connection.new('github.com', 443, :use_ssl => true)
    end
  
    let(:request) { Net::HTTP::Get.new('https://github.com/') }
  
    it 'works' do
      response = subject.perform(request)
      response.body.should_not be_nil
      response.body.should_not be_empty
      response.should be_a(Net::HTTPSuccess)
    end
    
  end
  
end