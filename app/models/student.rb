class Student < ActiveRecord::Base
  has_many :records
  has_many :comments

  def record_at(timeslot)
    records.find_by('start_time = ? AND end_time = ?', timeslot.start_time, timeslot.end_time)
  end
end
