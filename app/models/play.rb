class Play < ApplicationRecord
  validates :title, presence: true
  validate :valid_date_range
  validate :validate_other_plays_overlap

  def start_date
    date_range.first
  end

  def end_date
    date_range.last
  end

  def start_date=(date)
    date_range = [*date..end_date]
  end

  def end_date=(date)
    date_range = [*start_date..date]
  end

  private

  def valid_date_range
    unless date_range.is_a?(Range) && date_range.begin.is_a?(Date) && date_range.end.is_a?(Date) &&
      date_range.begin < date_range.end
      errors.add(:date_range, :invalid_date_range)
    end
  end

  def validate_other_plays_overlap
    sql = "date_range && daterange(:start_date, :end_date)"
    is_overlapping = Play.where(sql, start_date: date_range.begin, end_date: date_range.end).exists?
    errors.add(:date_range, :overlaps_with_other) if is_overlapping
  end
end
