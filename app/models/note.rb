class Note < ActiveRecord::Base
  extend FriendlyId

  friendly_id :title, use: [:slugged, :scoped], :scope => :trip
  belongs_to :trip

  # Dragonfly image
  image_accessor :image

  scope :with_latest_image, where('notes.image_uid is not null').order('notes.image_changed desc').limit(1)
  scope :recent, order('note_timestamp desc')
  scope :changed_after, lambda { |date| where('updated_at > ?', date) }

  def lead
    content.truncate(400, separator: ' ') if content
  end

  def image?
    image.present?
  end

  def image_path
    image.process(:resize, '500^').url if image?
  end

  def image_url
    request.protocol + request.host_with_port + image_path
  end

  def thumb_path
    image.process(:resize, '300x200^').process(:crop, width: 300, height: 200, gravity: 'c').url if image?
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

end
