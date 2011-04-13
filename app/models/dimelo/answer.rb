module Dimelo
  class Answer < Dimelo::API::Model
    
    path '/questions/%{question_id}/answers/%{id}'
    
    attributes :id, :body, :body_format, :flow_state, :user_id, :permalink, :created_at, :question_id
    submit_attributes :body, :user_id
    
    belongs_to :user
    belongs_to :question
    
  end
end
