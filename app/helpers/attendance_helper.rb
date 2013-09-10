module AttendanceHelper

  def link_to_period(slot)
    return '/%s/%s-%s' % [slot.start_time.strftime("%F"), slot.start_time.hour, slot.end_time.hour]
  end

  def format_hour(timeslot)
    timeslot.start_time.hour.to_s + ' - ' + timeslot.end_time.hour.to_s
  end

  def format_date_long(timeslot)
    timeslot.start_time.strftime('%A, %d %B %Y')
  end

  def format_date_short(timeslot)
    timeslot.start_time.strftime('%a, %e-%b')
  end
  
  def student_to_tag(student)
	student.id.to_s + student.name.split(" ").join("").downcase
  end

end
