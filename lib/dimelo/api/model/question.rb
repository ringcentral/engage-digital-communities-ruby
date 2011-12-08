module Dimelo
  class Question < Dimelo::API::Model
    
    attributes :id, :title, :body, :body_format, :flow_state, :score, :user_id,
               :category_id, :category_ids, :category_names, :star, :permalink,
               :created_at, :updated_at, :answers_count,
               :usefulnesses_yes_count, :usefulnesses_no_count
    
    submit_attributes :title, :body, :category_ids, :user_id
    
    belongs_to :user
    belongs_to :category
    has_many :answers
    
    def publish
      path = "#{compute_path(attributes)}/publish"
      response = client.transport(:post, path)
      self.attributes = Dimelo::API.decode_json(response)
      errors.empty?
    end
    
  end
end
