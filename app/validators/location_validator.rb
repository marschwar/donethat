class LocationValidator < ActiveModel::Validator
  def validate(record)
    if record.longitude.present? ^ record.latitude.present?
      record.errors[:base] << 'Invalid Location'
    end
    return if record.longitude.blank?

    unless in_range? record.longitude, -180, 180
      record.errors[:longitude] << 'Invalid Location'
    end

    unless in_range? record.latitude, -90, 90
      record.errors[:latitude] << 'Invalid Location'
    end
  end

private
  def in_range?(value, min, max)
    return false if value.blank? || value == BigDecimal.new(0)
    return false if value < BigDecimal.new(min)
    return false if value > BigDecimal.new(max)
    true
  end
end