module Dimelo::CCP
  class Membership < Dimelo::CCP::API::Model

    path 'users/%{user_id}/memberships/%{id}'

    attributes :id, :user_id, :role, :domain, :domain_application_id, :team
    submit_attributes :user_id, :role, :domain

    belongs_to :user

  end
end
