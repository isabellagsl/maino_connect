class PostTag < ApplicationRecord
    has_many :post_taggings, dependent: :destroy
    has_many :posts, through: :post_taggings

    post_tab.rb: validates :name, presence: true, uniqueness: true
end
