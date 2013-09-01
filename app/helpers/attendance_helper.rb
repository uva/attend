module AttendanceHelper

  def link_to_period(slot)
    return '/%s/%s-%s' % [slot.start_time.strftime("%F"), slot.start_time.hour, slot.end_time.hour]
  end

end
