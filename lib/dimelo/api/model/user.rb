module Dimelo
  class User < Dimelo::API::Model
    
    attributes :id, :firstname, :lastname, :signature, :email, :type, :username, :flow_state, :about, :avatar, :created_at, :updated_at
    submit_attributes :type, :firstname, :lastname, :email, :username, :avatar_url, :about
    
    has_many :memberships
    has_many :questions
    has_many :answers
    
    def avatar_url(size='normal')
      avatar.try(:[], size).try(:[], 'url')
    end
    
  end
end
