class Timeslot
  attr_reader :start_time, :end_time

  def initialize(start_datetime, end_datetime)
    @start_time = start_datetime
    @end_time = end_datetime
  end

  def previous
    Timeslot.new(@start_time.change(hour: @start_time.hour - 2), @end_time.change(hour: @end_time.hour - 2))
  end

  def next
    Timeslot.new(@start_time.change(hour: @start_time.hour + 2), @end_time.change(hour: @end_time.hour + 2))
  end

  def hour_s
    @start_time.hour.to_s + ' - ' + @end_time.hour.to_s
  end

  def date_s
    @start_time.strftime('%A, %d %B %Y')
  end

  def self.now
    current_time = Time.now
    Timeslot.at(current_time)
  end

  def self.at(datetime)
    # clip start and end to 9:00 -- 17:00
    start_hour = [[(datetime.hour + 1) / 2 * 2 - 1, 9].max, 15].min
    end_hour = [[(datetime.hour + 1) / 2 * 2 + 1, 11].max, 17].min
    Timeslot.new(datetime.change(hour: start_hour), datetime.change(hour: end_hour))
  end

  def self.parse(string, date = DateTime.now)
    slots = string.scan(/^(\d{1,2})-(\d{1,2})$/)
    Timeslot.new(date.change(hour: slots[0][0].to_i), date.change(hour: slots[0][1].to_i))
  end
end
