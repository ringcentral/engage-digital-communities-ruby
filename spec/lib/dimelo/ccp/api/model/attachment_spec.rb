# encoding: utf-8

require 'spec_helper'

describe Dimelo::CCP::Attachment do
  let(:client) { Dimelo::CCP::API::Client.new('https://domain-test.api.answers.dimelo.info/1.0', 'access_token' => 'foo') }

  describe Dimelo::CCP::QuestionAttachment do

    it 'use question path' do
      expect(client).to receive(:transport).with(:get, 'questions/1/attachments', {:offset=>0, :limit=>30}).and_return('[]')
      Dimelo::CCP::QuestionAttachment.find({:question_id => 1}, client)
    end

  end

  describe Dimelo::CCP::AnswerAttachment do

    it 'use answer path' do
      expect(client).to receive(:transport).with(:get, 'questions/2/answers/1/attachments', {:offset=>0, :limit=>30}).and_return('[]')
      Dimelo::CCP::AnswerAttachment.find({question_id: 2, answer_id: 1}, client)
    end

  end

end
