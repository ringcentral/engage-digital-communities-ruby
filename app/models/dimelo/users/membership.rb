module Dimelo
  module Users
    class Membership < Dimelo::API::Model
      
      path '/users/%{user_id}/memberships/%{id}'
      
      attributes :user_id, :role, :domain, :domain_application_id
      submit_attributes :user_id, :role, :domain
      
      belongs_to :user
      
    end
  end
end