module Dimelo::CCP
  class Category < Dimelo::CCP::API::Model
    path 'category_groups/%{category_group_id}/categories/%{id}'

    attributes :id, :category_group_id, :name, :description, :questions_count, :permalink, :picture
    alias :to_s :name

    belongs_to :category_group
    has_many :questions

  end
end
