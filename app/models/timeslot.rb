class Timeslot
  include Comparable
  attr_reader :start_time, :end_time

  SATURDAY = 6
  SUNDAY = 0

  START_HOUR_OF_THE_DAY = 9   # first hour of the day
  END_HOUR_OF_THE_DAY = 19    # last hour of the day
  PERIOD_LENGTH = 2.hours

  def initialize(start_datetime, end_datetime)
    @start_time = start_datetime
    @end_time = end_datetime
  end

  def previous
    new_start = @start_time - PERIOD_LENGTH
    if new_start.hour < START_HOUR_OF_THE_DAY
      new_start = new_start.change(hour: END_HOUR_OF_THE_DAY) - PERIOD_LENGTH - 1.day
      if new_start.wday == SATURDAY or new_start.wday == SUNDAY
        skip_days = (7 - new_start.wday) % 5
        new_start = new_start.advance(days: -skip_days)
      end
    end
    new_end = new_start + PERIOD_LENGTH
    Timeslot.new(new_start, new_end)
  end

  def next
    new_end = @end_time + PERIOD_LENGTH
    if new_end.hour > END_HOUR_OF_THE_DAY
      new_end = new_end.change(hour: START_HOUR_OF_THE_DAY) + PERIOD_LENGTH + 1.day
      if new_end.wday == SATURDAY or new_end.wday == SUNDAY
        skip_days = (new_end.wday + 1) % 5
        new_end = new_end.advance(days: skip_days)
      end
    end
    new_start = new_end - PERIOD_LENGTH
    Timeslot.new(new_start, new_end)
  end

  def <=>(other)
    if @start_time < other.start_time
      return -1
    elsif @start_time > other.start_time
      return 1
    else
      return 0
    end
  end

  alias eql? ==

  def hash
    [@start_time, @end_time].hash
  end

  def self.now
    current_time = Time.now
    Timeslot.at(current_time)
  end
  
  def self.at(datetime)
    # clip start and end to START-- and END_HOUR_OF_THE_DAY
    start_hour = [[(datetime.hour + 1) / 2 * 2 - 1, START_HOUR_OF_THE_DAY].max,
                  END_HOUR_OF_THE_DAY - 2].min
    end_hour = [[(datetime.hour + 1) / 2 * 2 + 1, START_HOUR_OF_THE_DAY + 2].max,
                END_HOUR_OF_THE_DAY].min
    Timeslot.new(datetime.change(hour: start_hour), datetime.change(hour: end_hour))
  end

  def self.parse(string, date = DateTime.now)
    slots = string.scan(/^(\d{1,2})-(\d{1,2})$/)
    Timeslot.new(date.change(hour: slots[0][0].to_i), date.change(hour: slots[0][1].to_i))
  end

  def self.start_of_day(date)
    date.change(hour: START_HOUR_OF_THE_DAY)
  end

  def self.end_of_day(date)
    date.change(hour: END_HOUR_OF_THE_DAY)
  end
end
