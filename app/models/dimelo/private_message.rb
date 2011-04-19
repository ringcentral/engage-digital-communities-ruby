module Dimelo
  class PrivateMessage < Dimelo::API::Model
    
    attributes :title, :body, :from_user_id, :to_user_id, :parent_id, :root_id, :created_at, :updated_at
    submit_attributes :title, :body, :from_user_id, :to_user_id, :parent_id
    
  end
end