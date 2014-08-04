require 'active_support/json'
require 'active_support/core_ext'
require 'faraday'
require 'uri'

module Dimelo

  autoload :Answer,         'dimelo/api/model/answer'
  autoload :Attachment,     'dimelo/api/model/attachment'
  autoload :Category,       'dimelo/api/model/category'
  autoload :CategoryGroup,  'dimelo/api/model/category_group'
  autoload :Feedback,       'dimelo/api/model/feedback'
  autoload :FeedbackComment,'dimelo/api/model/feedback_comment'
  autoload :Membership,     'dimelo/api/model/membership'
  autoload :PrivateMessage, 'dimelo/api/model/private_message'
  autoload :Question,       'dimelo/api/model/question'
  autoload :Role,           'dimelo/api/model/role'
  autoload :User,           'dimelo/api/model/user'

  # Attachments
  autoload :AnswerAttachment,           'dimelo/api/model/attachment'
  autoload :CommentAttachment,          'dimelo/api/model/attachment'
  autoload :FeedbackAttachment,         'dimelo/api/model/attachment'
  autoload :FeedbackCommentAttachment,  'dimelo/api/model/attachment'
  autoload :QuestionAttachment,         'dimelo/api/model/attachment'

  module API

    autoload :VERSION,          'dimelo/api/version'
    autoload :Client,           'dimelo/api/client'
    autoload :Connection,       'dimelo/api/connection'
    autoload :Model,            'dimelo/api/model'
    autoload :BasicObject,      'dimelo/api/basic_object'
    autoload :LazzyCollection,  'dimelo/api/lazzy_collection'

    require 'dimelo/api/error'

    class << self

      def decode_json(document)
        ActiveSupport::JSON.decode(document)
      end

      def encode_json(object)
        ActiveSupport::JSON.encode(object)
      end

    end

    module Common

      autoload :Openable, 'dimelo/api/common/openable'
      autoload :Publishable, 'dimelo/api/common/publishable'
      autoload :Starrable, 'dimelo/api/common/starrable'

    end

  end
end
