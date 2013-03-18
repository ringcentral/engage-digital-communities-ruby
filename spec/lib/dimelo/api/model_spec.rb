require 'spec_helper'

describe Dimelo::API::Model do

  class User < Dimelo::API::Model
    path '/groups/%{group_id}/users/%{id}'
    attributes :id, :firstname, :lastname
  end

  describe '.new' do

    subject{ User.new(:id => 1, :firstname => 'Homer Jay', :lastname => 'Simpson') }

    its(:id) { should be 1 }
    its(:firstname) { should be_eql 'Homer Jay' }
    its(:lastname) { should be_eql 'Simpson' }

  end

  describe '.parse' do

    describe 'one' do

      subject do
        User.parse(%[
          {
            "id": 1,
            "firstname": "Homer Jay",
            "lastname": "Simpson"
          }
        ])
      end

      it { should be_an(User) }
      its(:id) { should be 1 }
      its(:firstname) { should be_eql 'Homer Jay' }
      its(:lastname) { should be_eql 'Simpson' }

    end

    describe 'many' do

      subject do
        User.parse(%[
          [
            {
              "id": 1,
              "firstname": "Homer Jay",
              "lastname": "Simpson"
            },
            {
              "id": 2,
              "firstname": "Marjorie 'Marge'",
              "lastname": "Simpson"
            }
          ]
        ])
      end

      its(:size) { should be 2 }

      it 'return a user collection' do
        subject.each do |u|
          u.should be_an(User)
        end
      end

    end

  end

  describe '.find' do

    let(:client) { Dimelo::API::Client.new('https://domain-test.api.users.dimelo.com/1.0', 'access_token' => 'foo') }

    it 'compute index path' do
      client.should_receive(:transport).with(:get, '/groups/42/users/', {:query => {:offset=>0, :limit=>30}}).and_return('[]')
      User.find({:group_id => 42}, client)
    end

    it 'compute show path' do
      client.should_receive(:transport).with(:get, '/groups/42/users/1', {:query => {:offset=>0, :limit=>30}}).and_return('{}')
      User.find({:group_id => 42, :id => 1}, client)
    end

    it 'send extra criterias as query' do
      client.should_receive(:transport).with(:get, '/groups/42/users/', {:query => {:order => 'foo', :egg => 'spam', :offset=>0, :limit=>30}}).and_return('[]')
      User.find({:group_id => 42, :order => 'foo', :egg => 'spam'}, client)
    end

    it 'send the result to .parse' do
      client.should_receive(:transport).at_least(1).times.and_return('JSON')
      User.should_receive(:parse).at_least(1).times.with('JSON', client)
      User.find({:group_id => 42}, client)
    end

  end

  describe '.submit_attributes' do

    before :each do
      class Article < Dimelo::API::Model
        attributes :id, :category_ids
        submit_attributes :id, :category_ids
      end
    end

    after :each do
      Object.send(:remove_const, 'Article')
    end

    it 'does not send param when not sent' do
      Article.new.submit_attributes.should == {}
    end

    it 'sends only param specified' do
      Article.new(:id => 1).submit_attributes.should == {:id => 1}
    end

    it 'sends empty string is precised' do
      Article.new(:id => 1, :category_ids => '').submit_attributes.should == {:id => 1, :category_ids => ''}
    end

  end

end
