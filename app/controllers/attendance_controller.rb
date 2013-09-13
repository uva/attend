class AttendanceController < ApplicationController

  prepend_before_filter CASClient::Frameworks::Rails::Filter
  before_filter :is_assistant?

  def index
    if params[:date] and params[:timeslot]
      date = Time.parse(params[:date]) # not DateTime.parse which always returns in UTC
      @timeslot = Timeslot.parse(params[:timeslot], date)
    else
      @timeslot = Timeslot.now      
    end

    @students = Student.includes(:records).joins("LEFT OUTER JOIN records "\
                              "ON records.student_id = students.id "\
                              "AND records.start_time = '#{@timeslot.start_time}' "\
                              "AND records.end_time = '#{@timeslot.end_time}'")
    @students.load
  end

  def update
    start_time = Time.parse(params[:start_time])
    end_time = Time.parse(params[:end_time])
    record_params = {student_id: params[:student_id], start_time: start_time, end_time: end_time}

    if params[:attending] == "true"
      Record.create(record_params)
    else
      r = Record.find_by(record_params)
      r.destroy unless r.nil?
    end
    render text: 'OK'
  end

  def overview_per_week
    current_week = Time.now.strftime('%V').to_i
    @timeslots_per_week = (36..current_week).inject({}) {|result, week_number|
      result[week_number] = records_per_timeslot_for_week(week_number)
      result
    }
  end

  private
    def records_per_timeslot_for_week(week_number)
      first_timeslot = Timeslot.at(Date.commercial(2013, week_number, 1).to_time)
      timeslots_this_week = (1..24).inject([first_timeslot]) {|timeslots|
        timeslots << timeslots.last.next
        timeslots
      }
      start_times = timeslots_this_week.map(&:start_time)
      records = Record.where(start_time: start_times)
      records_per_timeslot = {}
      records_per_timeslot.default = 0
      records_per_timeslot = records.inject(records_per_timeslot) {|result, record|
        timeslot = Timeslot.new(record.start_time, record.end_time)
        if result[timeslot]
          result[timeslot] += 1
        end
        result
      } 
    end
end
