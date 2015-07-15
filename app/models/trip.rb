class Trip < ActiveRecord::Base
  extend FriendlyId

  friendly_id :title, use: :slugged

  belongs_to :user

  has_many :notes, dependent: :destroy

  validates :uid, presence: true
  validates :user, presence: true
  validates :title, presence: true

  scope :recent, -> { order('updated_at desc') }
  scope :first_n, -> (count=1) { limit(count) }
  scope :changed_after, lambda { |timestamp| where('updated_at > ?', timestamp) }

  def image?
    !!image
  end

  def thumb_path
    image.thumb.url if image?
  end

  def image
    @image ||= notes.with_image.recent.first.try(:picture)
  end

  def carousel_image_path
    image.carousel.url if image?
  end

end
