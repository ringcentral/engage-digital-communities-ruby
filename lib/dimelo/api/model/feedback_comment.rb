module Dimelo
  class FeedbackComment < Dimelo::API::Model
    
    path '/feedbacks/%{feedback_id}/comments/%{id}'
    
    attributes :id, :feedback_id, :body, :body_format, :flow_state, :user_id, :type, :status_id, :created_at, :updated_at, :permalink
    submit_attributes :body, :user_id, :feedback_id
    
    belongs_to :user
    belongs_to :feedback
    
  end
end
