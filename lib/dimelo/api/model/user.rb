module Dimelo
  class User < Dimelo::API::Model
    CUSTOM_FIELD_COUNT = 10
    CUSTOM_FIELD_ATTRIBUTES = (1..CUSTOM_FIELD_COUNT).map { |i| "custom_field_#{i}".to_sym }.freeze

    attributes :id, :firstname, :lastname, :signature, :email, :private_message, :type, :username, :flow_state, :about, :avatar, :created_at, :updated_at
    attributes *CUSTOM_FIELD_ATTRIBUTES

    submit_attributes :type, :firstname, :lastname, :email, :username, :avatar_url, :about
    
    has_many :memberships
    has_many :questions
    has_many :answers
    has_many :feedbacks
    
    def avatar_url(size='normal')
      avatar.try(:[], size).try(:[], 'url')
    end
    
  end
end
