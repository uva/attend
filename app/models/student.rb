class Student < ActiveRecord::Base
  has_many :records
  has_many :comments

  def record_at(timeslot)
    records.find_by('start_time = ? AND end_time = ?', timeslot.start_time, timeslot.end_time)
  end

  def hours_per_week
    weekly_records = records.order('start_time DESC').group_by(&:week)
    weekly_records.each do |week, records|
      weekly_records[week] = records.inject(0) {|sum, r| sum + r.duration }
    end
  end
end
