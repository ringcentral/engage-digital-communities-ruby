module Dimelo
  module Users
    class User < Dimelo::API::Model
      
      path '/users/%{id}'
      
      attr_accessor :avatar_url
      attributes :id, :firstname, :lastname, :signature, :email, :type, :username, :flow_state, :about, :avatar, :created_at, :updated_at
      submit_attributes :type, :firstname, :lastname, :email, :username, :avatar_url, :about
      
      has_many :memberships
      
    end
  end
end