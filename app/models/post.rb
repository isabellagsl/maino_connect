class Post < ApplicationRecord
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :post_taggings, dependent: :destroy
  has_many :post_tags, through: :post_taggings

  scope :filter_by_title, ->(title) { where("title ILIKE ?", "%#{title}%") if title.present? }
  scope :filter_by_tags, ->(tags) { joins(:post_tags).where(post_tags: { name: tags }).distinct if tags.present? }
end
