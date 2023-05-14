class Play < ApplicationRecord
  validates :title, presence: true
  validate :valid_date_range

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
      errors.add(:date_range, "must be a valid date range with a beginning date smaller than its end date")
    end
  end
end
