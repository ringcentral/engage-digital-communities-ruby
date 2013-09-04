# encoding: utf-8

require 'spec_helper'

describe Dimelo::Attachment do
  let(:client) { Dimelo::API::Client.new('https://domain-test.api.answers.dimelo.info/1.0', 'access_token' => 'foo') }

  describe 'with question_id' do

    it 'use question path' do
      client.should_receive(:transport).with(:get, 'questions/1/attachments', {:offset=>0, :limit=>30}).and_return('[]')
      Dimelo::Attachment.find({:question_id => 1}, client)
    end

  end

  describe 'with question id and answer_id' do

    it 'use answer path' do
      client.should_receive(:transport).with(:get, 'questions/2/answers/1/attachments', {:offset=>0, :limit=>30}).and_return('[]')
      Dimelo::Attachment.find({question_id: 2, answer_id: 1}, client)
    end

  end

end
