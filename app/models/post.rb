class Post < ApplicationRecord
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :post_taggings, dependent: :destroy
  has_many :post_tags, through: :post_taggings

end
