module Dimelo
  class Answer < Dimelo::API::Model
    include ::Dimelo::API::Common::Publishable
    
    path '/questions/%{question_id}/answers/%{id}'
    
    attributes :id, :body, :body_format, :flow_state, :user_id, :stamp, :permalink, :created_at, :updated_at, :question_id, :comments_count, :ipaddr, :question_flow_state
    submit_attributes :body, :user_id, :question_id
    
    belongs_to :user
    belongs_to :question
    
    def admin_stamp
      path = "#{compute_path(attributes)}/admin_stamp"
      response = client.transport(:post, path)
      self.attributes = Dimelo::API.decode_json(response)
      errors.empty?
    end
    
  end
end
