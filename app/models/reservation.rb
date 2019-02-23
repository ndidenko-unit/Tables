class Reservation < ApplicationRecord
  belongs_to :table
  belongs_to :user

  validates :user, presence: true
  validates :table, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :validate_date_time, on: [:create, :update]

  def validate_date_time
    # we don't need to complete validations if start_time or end_time is nil
    return if start_time.nil? || end_time.nil?

    validate_dates_in_past
    validate_dates_direction
    validate_dates_step
    validate_restaurant_schedule

    @table_reservation = self.class.where(table_id: table_id)

    validate_dates_overlaps
    validate_dates_around
  end

  private

  def validate_dates_in_past
    errors.add(:start_time, 'in_past') if start_time < Time.now
    errors.add(:end_time, 'in_past') if end_time < Time.now
  end

  def validate_dates_direction
    errors.add(:start_time, 'greater_than_end') if start_time > end_time
    errors.add(:end_time, 'less_than_start') if end_time < start_time
  end

  def validate_dates_step
    errors.add(:base, 'step_not_30_min') if ((end_time.to_i - start_time.to_i) % 30*60).positive?
  end

  def validate_restaurant_schedule
    errors.add(:base, 'outside_work_schedule') if start_time < table.restaurant.open_time.to_time.utc
    errors.add(:base, 'outside_work_schedule') if end_time > table.restaurant.close_time.to_time.utc
  end

  def validate_dates_overlaps
    start_overlapping = @table_reservation.where(start_time: start_time..end_time)
    end_overlapping = @table_reservation.where(end_time: start_time..end_time)
    errors.add(:start_time, 'overlap') if start_overlapping.any?
    errors.add(:end_time, 'overlap') if end_overlapping.any?
  end

  def validate_dates_around
    around = @table_reservation.where('start_time <= ? AND end_time >= ?', start_time, end_time)
    errors.add(:start_time, 'surrounded') if around.any?
    errors.add(:end_time, 'surrounded') if around.any?
  end
end
