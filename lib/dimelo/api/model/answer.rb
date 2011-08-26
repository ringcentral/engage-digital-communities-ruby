module Dimelo
  class Answer < Dimelo::API::Model
    
    path '/questions/%{question_id}/answers/%{id}'
    
    attributes :id, :body, :body_format, :flow_state, :user_id, :stamp, :permalink, :created_at, :updated_at, :question_id, :comments_count
    submit_attributes :body, :user_id, :question_id
    
    belongs_to :user
    belongs_to :question
    
  end
end
