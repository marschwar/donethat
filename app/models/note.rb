class Note < ActiveRecord::Base
  extend FriendlyId

  friendly_id :title, use: [:slugged, :scoped], :scope => :trip
  belongs_to :trip

  scope :recent, -> { order('note_timestamp desc') }
  scope :changed_after, lambda { |date| where('updated_at > ?', date) }

  def lead
    content.truncate(400, separator: ' ') if content
  end

  def image?
    image.present?
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
