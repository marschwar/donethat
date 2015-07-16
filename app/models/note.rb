class Note < ActiveRecord::Base
  extend FriendlyId

  mount_uploader :picture, PictureUploader

  friendly_id :title, use: [:slugged, :scoped], :scope => :trip
  belongs_to :trip

  validates_presence_of :title
  validates :title, length: { in: 5..50 }
  validates_presence_of :content
  validates_with ::LocationValidator

  scope :recent, -> { order('note_date desc') }
  scope :changed_after, lambda { |date| where('updated_at > ?', date) }
  scope :with_image, -> { where('picture is not null') }

  attr_accessor :picture_cache

  def lead
    content.truncate(400, separator: ' ') if content
  end

  def image?
    image.present?
  end

  def image
    picture
  end

  def image_path
    image.main.url if image?
  end

  def thumb_path
    image.thumb.url if image?
  end

  def create_ts
    created_at.to_f * 1000
  end

end
