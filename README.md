# RingCentral Engage Communities Ruby API Client

[![Build Status](https://github.com/ringcentral/engage-digital-communities-ruby/workflows/Ruby%20CI/badge.svg)](https://github.com/ringcentral/engage-digital-communities-ruby/actions)

RubyClient for the Engage Communities.

This client support most of Engage Communities resources, can read and write them, paginates with cursor like interface, supports attachments and supports proper validation and error format.

This is heavily used internally at Engage Communities.

# Compatibility

Compatible and tested with:

- Ruby MRI 2.5, 2.6, 2.7, Head and Jruby-head
- ActiveSupport 4+, 5+, 6+, Head


## Installation

Gemfile:

```ruby
gem 'dimelo_ccp_api'
```

## Usage

```ruby
require 'dimelo_ccp_api'


users_client = Dimelo::CCP::API::Client.new('https://domain-test.api.users.dimelo.com/1.0', 'access_token' => ENV['DIMELO_API_KEY'])
answers_client = Dimelo::CCP::API::Client.new('https://domain-test.api.answers.dimelo.com/1.0', 'access_token' => ENV['DIMELO_API_KEY'])
feedbacks_client = Dimelo::CCP::API::Client.new('https://domain-test.api.ideas.dimelo.com/1.0', 'access_token' => ENV['DIMELO_API_KEY'])

user = Dimelo::CCP::User.find(1, users_client)
questions = user.questions(answers_client)
puts "question count: #{questions.count}"

questions.each do |question, i|
  answers = question.answers
  puts "#{i} of #{questions.count} => answer count: #{answers.count}"
  answers.each do |answer|
    answer.question_flow_state = "lol"
  end
end

feedbacks = Dimelo::CCP::Feedback.find({ :order => 'updated_at.desc' }, feedbacks_client)
puts "feedbacks count: #{feedbacks.count}"
puts "feedbacks not by anonymous and superadmin: #{feedbacks.select{|f| f.user_id.present?}.count}"
```

## Contributing

1. Fork it ( http://github.com/ringcentral/engage-digital-communities-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
