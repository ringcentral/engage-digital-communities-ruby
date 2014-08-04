require 'spec_helper'

describe Dimelo::API::Model do

  class User < Dimelo::API::Model
    path 'groups/%{group_id}/users/%{id}'
    attributes :id, :firstname, :lastname
  end

  class BaseUser < Dimelo::API::Model
    attributes :id, :firstname, :lastname
  end

  describe '.new' do

    it "creates user with given attributes" do
      user = User.new(:id => 1, :firstname => 'Homer Jay', :lastname => 'Simpson')
      expect(user.id).to eq(1)
      expect(user.firstname).to eq('Homer Jay')
      expect(user.lastname).to eq('Simpson')
    end

  end

  describe '.parse' do

    it 'parses one json record' do
      user = User.parse(%[
          {
            "id": 1,
            "firstname": "Homer Jay",
            "lastname": "Simpson"
          }
        ])

      expect(user).to be_a(User)
      expect(user.id).to eq(1)
      expect(user.firstname).to eq('Homer Jay')
      expect(user.lastname).to eq('Simpson')
    end

    it 'parses many json records' do
      user = User.parse(%[
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

      expect(user.size).to eq(2)
      user.each do |u|
        expect(u).to be_a(User)
      end

    end

  end

  describe '.path' do
    let(:user) { BaseUser.new }

    it 'should not have leading and trailling "/" to not override path_prefix' do
      expect(user.compute_path).to eq('base_users')
    end

    it 'should work when computed with criteria' do
      expect(user.compute_path(:id => 1)).to eq('base_users/1')
    end

  end

  describe '.find' do

    let(:client) { Dimelo::API::Client.new('https://domain-test.api.users.dimelo.com/1.0', 'access_token' => 'foo') }

    it 'compute index path' do
      expect(client).to receive(:transport).with(:get, 'groups/42/users', {:offset=>0, :limit=>30}).and_return('[]')
      User.find({:group_id => 42}, client)
    end

    it 'compute show path' do
      expect(client).to receive(:transport).with(:get, 'groups/42/users/1', {:offset=>0, :limit=>30}).and_return('{}')
      User.find({:group_id => 42, :id => 1}, client)
    end

    it 'send extra criterias as payload' do
      expect(client).to receive(:transport).with(:get, 'groups/42/users', {:order => 'foo', :egg => 'spam', :offset=>0, :limit=>30}).and_return('[]')
      User.find({:group_id => 42, :order => 'foo', :egg => 'spam'}, client)
    end

    it 'send the result to .parse' do
      expect(client).to receive(:transport).at_least(1).times.and_return('JSON')
      expect(User).to receive(:parse).at_least(1).times.with('JSON', client)
      User.find({:group_id => 42}, client)
    end

  end

  describe '#tracked_attributes' do

    before :each do
      class Article < Dimelo::API::Model
        attributes :id, :category_ids
      end
    end

    after :each do
      Object.send(:remove_const, 'Article')
    end

    it 'should returns only mass-assigned attributes' do
      expect(Article.new(:category_ids => nil).tracked_attributes).to eq([:category_ids])
    end

    it 'should works on single assigning' do
      article = Article.new
      article.category_ids = nil
      expect(article.tracked_attributes).to eq([:category_ids])
    end

    it 'should returns nothing if not set' do
      expect(Article.new.tracked_attributes).to eq([])
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
      expect(Article.new.submit_attributes).to eq({})
    end

    it 'sends only param specified' do
      expect(Article.new(:id => 1).submit_attributes).to eq({:id => 1})
    end

    it 'sends empty string is precised' do
      expect(Article.new(:id => 1, :category_ids => nil).submit_attributes).to eq({:id => 1, :category_ids => nil})
    end

  end

end
