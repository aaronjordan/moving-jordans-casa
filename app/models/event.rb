class Event < ApplicationRecord
  has_rich_text :desc
  has_one_attached :cover_image

  def start_local
    start_time.in_time_zone("Central Time (US & Canada)")
  end

  def end_local
    end_time.in_time_zone("Central Time (US & Canada)")
  end
end
