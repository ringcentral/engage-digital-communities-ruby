module Dimelo
  class Membership < Dimelo::API::Model

    path 'users/%{user_id}/memberships/%{id}'

    attributes :id, :user_id, :role, :domain, :domain_application_id
    submit_attributes :user_id, :role, :domain

    belongs_to :user

  end
end
