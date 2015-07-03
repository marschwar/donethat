class Note < ActiveRecord::Base
  extend FriendlyId

  mount_uploader :picture, PictureUploader

  friendly_id :title, use: [:slugged, :scoped], :scope => :trip
  belongs_to :trip

  validates_presence_of :title
  validates :title, length: { in: 5..50 }
  validates_presence_of :content
  validates_with ::LocationValidator
  validates :note_timestamp, numericality: true

  scope :recent, -> { order('note_timestamp desc') }
  scope :changed_after, lambda { |date| where('updated_at > ?', date) }
  scope :with_image, -> { where('picture is not null') }

  attr_accessor :picture_cache
  attr_accessor :note_datetime

  def lead
    content.truncate(400, separator: ' ') if content
  end

  def image?
    picture.present?
  end

  def image_path
    picture.main.url if image?
  end

  def thumb_path
    picture.thumb.url if image?
  end

  def create_ts
    created_at.to_f * 1000
  end

  def as_json(options = {})
    options.merge!(
      {
        :only => [:uid, :title, :content, :longitude, :latitude, :image_changed],
        :methods => [:image_path, :created_ts]
      }
    )
    super options
  end

  def note_datetime=(string)
    if string
      @note_datetime = string.to_datetime rescue nil
      self.note_timestamp = @note_datetime.to_i if @note_datetime
    else
      note_timestamp = nil
      @note_datetime = nil
    end
  end

  def note_datetime
    @note_datetime ||= Time.at(note_timestamp).to_datetime if note_timestamp
  end

end
