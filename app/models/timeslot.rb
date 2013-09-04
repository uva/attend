class Timeslot
  attr_reader :start_time, :end_time

  @@START_HOUR_OF_THE_DAY = 9   # first hour of the day
  @@END_HOUR_OF_THE_DAY = 17    # last hour of the day
  @@PERIOD_LENGTH = 2.hours

  def initialize(start_datetime, end_datetime)
    @start_time = start_datetime
    @end_time = end_datetime
  end

  def previous
    new_start = @start_time - @@PERIOD_LENGTH
    if new_start.hour < @@START_HOUR_OF_THE_DAY
      new_start = new_start.change(hour: @@END_HOUR_OF_THE_DAY) - @@PERIOD_LENGTH - 1.day
    end
    new_end = new_start + @@PERIOD_LENGTH
    Timeslot.new(new_start, new_end)
  end

  def next
    new_end = @end_time + @@PERIOD_LENGTH
    if new_end.hour > @@END_HOUR_OF_THE_DAY
      new_end = new_end.change(hour: @@START_HOUR_OF_THE_DAY) + @@PERIOD_LENGTH + 1.day
    end
    new_start = new_end - @@PERIOD_LENGTH
    Timeslot.new(new_start, new_end)
  end

  def hour_s
    @start_time.hour.to_s + ' - ' + @end_time.hour.to_s
  end

  def date_s
    @start_time.strftime('%A, %d %B %Y')
  end

  def self.PERIOD_LENGTH
    @@PERIOD_LENGTH
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

  def self.start_of_day(date)
    date.change(hour: @@START_HOUR_OF_THE_DAY)
  end

  def self.end_of_day(date)
    date.change(hour: @@END_HOUR_OF_THE_DAY)
  end
end
