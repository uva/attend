class AttendanceController < ApplicationController

  prepend_before_filter CASClient::Frameworks::Rails::Filter
  before_filter :is_authorized?, :except => [:unauthorized]

  def unauthorized
  end

  def index
    if params[:date] and params[:timeslot]
      date = Time.parse(params[:date]) # not DateTime.parse which always returns in UTC
      @timeslot = Timeslot.parse(params[:timeslot], date)
    else
      @timeslot = Timeslot.now      
    end

    @students = Student.joins("LEFT OUTER JOIN records "\
                              "ON records.student_id = students.id "\
                              "AND records.start_time = '#{@timeslot.start_time}' "\
                              "AND records.end_time = '#{@timeslot.end_time}'")
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
  end
end
