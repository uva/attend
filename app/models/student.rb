class Student < ActiveRecord::Base
  has_many :records
  has_many :comments

  def record_at(timeslot)
    records.find_by('start_time = ? AND end_time = ?', timeslot.start_time, timeslot.end_time)
  end

  def hours_per_week(week)
    time_range = Time.now.change(week: week).all_week
    records.where(start_time: time_range).count
  end
end
