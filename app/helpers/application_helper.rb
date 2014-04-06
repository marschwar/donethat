module ApplicationHelper

  def format_date(date)
    date.present? ? date.to_formatted_s(:DDMMYYYY) : ''
  end
end
