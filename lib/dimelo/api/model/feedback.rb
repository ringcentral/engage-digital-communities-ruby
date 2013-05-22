module Dimelo
  class Feedback < Dimelo::API::Model
    include ::Dimelo::API::Common::Publishable

    attributes :id, :title, :body, :body_format, :flow_state, :score, :user_id,
               :category_id, :category_ids, :category_names, :status_id, :star,
               :closed, :comments_count, :positive_votes_count, :negative_votes_count,
               :permalink, :ipaddr, :created_at, :updated_at

    submit_attributes :title, :body, :body_format, :category_ids, :user_id

    belongs_to :user
    belongs_to :category
    has_many :feedback_comments
    alias :comments :feedback_comments

  end
end
