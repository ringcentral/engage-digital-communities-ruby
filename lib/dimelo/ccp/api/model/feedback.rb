module Dimelo::CCP
  class Feedback < Dimelo::CCP::API::Model
    include ::Dimelo::CCP::API::Common::Openable
    include ::Dimelo::CCP::API::Common::Publishable
    include ::Dimelo::CCP::API::Common::Starrable

    attributes :id, :title, :body, :body_format, :flow_state, :score, :user_id,
               :category_id, :category_ids, :category_names, :status_id, :star, :starred_at,
               :closed, :attachments_count, :comments_count, :positive_votes_count, :negative_votes_count,
               :permalink, :ipaddr, :created_at, :updated_at

    submit_attributes :title, :body, :body_format, :category_ids, :user_id, :created_at

    belongs_to :user
    belongs_to :category
    has_many :feedback_comments
    alias :comments :feedback_comments

  end
end
