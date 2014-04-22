class Trip < ActiveRecord::Base
  extend FriendlyId

  friendly_id :title, use: :slugged

  belongs_to :user

  has_many :notes, :dependent => :destroy

  validates :uid, presence: true
  validates :user, presence: true
  validates :title, presence: true

  scope :publics, -> { where(public: true) }
  scope :owned_by, lambda { |user| where(user_id: user) }
  scope :recent, -> { order('updated_at desc') }
  scope :changed_after, lambda { |timestamp| where('updated_at > ?', timestamp) }

  # visible scope
  def self.visible(user)
    user.blank? ? publics : where("trips.user_id = ? or trips.public = ?", user, true)
  end

  def image?
#    notes.with_latest_image.present?
    true
  end

  def thumb_path
    note = notes.with_latest_image.first
    image = note.present? ? note.image : dummy_image
    image.thumb('450x300#').url
  end

  def carousel_image_path
    note = notes.with_latest_image.first
    image = note.present? ? note.image : dummy_image
#    image.thumb('300x200#').url
    image.process(:resize, '960^').process(:crop, width: 960, height: 500, gravity: 'c').url
  end

private

  def dummy_image
    image = Dragonfly.app.generate(:plain, 800, 600, 'rgba(128,128,128,0.5)')
  end

end
