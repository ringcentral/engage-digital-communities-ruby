module Dimelo::CCP
  class Answer < Dimelo::CCP::API::Model
    include ::Dimelo::CCP::API::Common::Publishable

    path 'questions/%{question_id}/answers/%{id}'

    attributes  :id, :body, :body_format, :flow_state, :user_id, :permalink,
                :attachments_count, :comments_count,
                :created_at, :updated_at, :question_id, :ipaddr, :question_flow_state

    submit_attributes :body, :body_format, :user_id, :question_id

    belongs_to :user
    belongs_to :question

    has_many :answer_attachments

    def admin_stamp
      path = "#{compute_path(attributes)}/admin_stamp"
      response = client.transport(:post, path)
      self.attributes = Dimelo::CCP::API.decode_json(response)
      errors.empty?
    end

    def author_stamp
      path = "#{compute_path(attributes)}/author_stamp"
      response = client.transport(:post, path)
      self.attributes = Dimelo::CCP::API.decode_json(response)
      errors.empty?
    end

    def unstamp
      path = "#{compute_path(attributes)}/stamp"
      response = client.transport(:delete, path)
      self.attributes = Dimelo::CCP::API.decode_json(response)
      errors.empty?
    end
  end
end
