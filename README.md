# Dimelo CCP API [![Build Status](https://travis-ci.org/dimelo/dimelo_ccp_api.svg?branch=master)](https://travis-ci.org/dimelo/dimelo_ccp_api) [![Code Climate](https://codeclimate.com/github/dimelo/dimelo_ccp_api.png)](https://codeclimate.com/github/dimelo/dimelo_ccp_api) [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/dimelo/dimelo_ccp_api)

Ruby client for the Dimelo Customer Community Platform

This client support most of Dimelo CCP resources, can read and write them, paginates with cursor like interface, supports attachments and supports proper validation and error format.

This is heavily used internaly at Dimelo.

# Compatibility

Compatible and tested with:

- Ruby 2.0, 2.1, 2.2 and Jruby-head
- ActiveSupport 3.0+, 4.0.x and 4.1.x


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

1. Fork it ( http://github.com/dimelo/dimelo_ccp_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
