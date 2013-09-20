module AttendanceHelper

  def link_to_period(slot)
    return '/%s/%s-%s' % [slot.start_time.localtime.strftime("%F"),
						  slot.start_time.localtime.hour,
						  slot.end_time.localtime.hour]
  end

  def format_hours(timeslot, separator=' - ')
    timeslot.start_time.localtime.hour.to_s + separator + timeslot.end_time.localtime.hour.to_s
  end

  def format_date_long(timeslot)
    timeslot.start_time.localtime.strftime('%A, %d %B %Y')
  end

  def format_date_short(timeslot)
    timeslot.start_time.localtime.strftime('%a, %e-%b')
  end
  
  def student_to_tag(student)
	student.id.to_s + student.name.split(" ").join("").downcase
  end

end
