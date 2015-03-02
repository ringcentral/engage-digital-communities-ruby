module Dimelo::CCP
  class User < Dimelo::CCP::API::Model
    CUSTOM_FIELD_COUNT = 10
    CUSTOM_FIELD_ATTRIBUTES = (1..CUSTOM_FIELD_COUNT).map { |i| "custom_field_#{i}".to_sym }.freeze

    attributes :id, :firstname, :lastname, :signature, :email, :private_message, :type, :username, :flow_state, :about, :avatar, :created_at, :updated_at, :blocked, :team
    attributes *CUSTOM_FIELD_ATTRIBUTES

    submit_attributes :type, :firstname, :lastname, :email, :username, :avatar_url, :about, :password, :created_at, :confirmed_at, *CUSTOM_FIELD_ATTRIBUTES

    has_many :memberships
    has_many :questions
    has_many :answers
    has_many :feedbacks

    def avatar_url(size='normal')
      avatar.try(:[], size).try(:[], 'url')
    end

    # Blocks the specified user
    def block
      path = "#{compute_path(attributes)}/block"
      response = client.transport(:post, path)
      self.attributes = Dimelo::CCP::API.decode_json(response)
      errors.empty?
    end

    # Unblocks the specified user
    def unblock
      path = "#{compute_path(attributes)}/unblock"
      response = client.transport(:post, path)
      self.attributes = Dimelo::CCP::API.decode_json(response)
      errors.empty?
    end

  end
end
