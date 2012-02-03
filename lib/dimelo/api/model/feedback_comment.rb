module Dimelo
  class FeedbackComment < Dimelo::API::Model
    
    STATUS_COMMENT_PATH = '/feedbacks/%{feedback_id}/status_comments/%{id}'
    COMMENT_PATH = '/feedbacks/%{feedback_id}/comments/%{id}'
    
    path COMMENT_PATH
    
    attributes :id, :feedback_id, :body, :body_format, :flow_state, :user_id, :type, :status_id, :created_at, :updated_at, :permalink
    submit_attributes :body, :user_id, :feedback_id, :status_id
    
    belongs_to :user
    belongs_to :feedback
    
    def create
      self.class.path(STATUS_COMMENT_PATH) if status_id
      super
    ensure
      self.class.path(COMMENT_PATH) if status_id
    end
    
    def update
      self.class.path(STATUS_COMMENT_PATH) if status_id
      super
    ensure
      self.class.path(COMMENT_PATH) if status_id
    end
    
  end
end
