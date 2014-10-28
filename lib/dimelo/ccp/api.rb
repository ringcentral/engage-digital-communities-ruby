require 'active_support'
require 'active_support/json'
require 'active_support/core_ext'
require 'faraday'
require 'uri'

module Dimelo
  module CCP

    autoload :Answer,         'dimelo/ccp/api/model/answer'
    autoload :Attachment,     'dimelo/ccp/api/model/attachment'
    autoload :Category,       'dimelo/ccp/api/model/category'
    autoload :CategoryGroup,  'dimelo/ccp/api/model/category_group'
    autoload :Feedback,       'dimelo/ccp/api/model/feedback'
    autoload :FeedbackComment,'dimelo/ccp/api/model/feedback_comment'
    autoload :Membership,     'dimelo/ccp/api/model/membership'
    autoload :PrivateMessage, 'dimelo/ccp/api/model/private_message'
    autoload :Question,       'dimelo/ccp/api/model/question'
    autoload :Role,           'dimelo/ccp/api/model/role'
    autoload :User,           'dimelo/ccp/api/model/user'
    autoload :Webhook,           'dimelo/ccp/api/model/webhook'

    # Attachments
    autoload :AnswerAttachment,           'dimelo/ccp/api/model/attachment'
    autoload :CommentAttachment,          'dimelo/ccp/api/model/attachment'
    autoload :FeedbackAttachment,         'dimelo/ccp/api/model/attachment'
    autoload :FeedbackCommentAttachment,  'dimelo/ccp/api/model/attachment'
    autoload :QuestionAttachment,         'dimelo/ccp/api/model/attachment'

    module API

      autoload :VERSION,          'dimelo/ccp/api/version'
      autoload :Client,           'dimelo/ccp/api/client'
      autoload :Connection,       'dimelo/ccp/api/connection'
      autoload :Model,            'dimelo/ccp/api/model'
      autoload :BasicObject,      'dimelo/ccp/api/basic_object'
      autoload :LazzyCollection,  'dimelo/ccp/api/lazzy_collection'

      require 'dimelo/ccp/api/error'

      class << self

        def decode_json(document)
          ActiveSupport::JSON.decode(document)
        end

        def encode_json(object)
          ActiveSupport::JSON.encode(object)
        end

      end

      module Common

        autoload :Openable, 'dimelo/ccp/api/common/openable'
        autoload :Publishable, 'dimelo/ccp/api/common/publishable'
        autoload :Starrable, 'dimelo/ccp/api/common/starrable'

      end
    end
  end
end
