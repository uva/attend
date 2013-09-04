class StudentsController < ApplicationController

  def show
    @student = Student.includes(:comments).find(params[:id])
    weeks = (-8..0).collect {|i| Time.now.advance(weeks: i).all_week}
    records = @student.records.order('start_time DESC').group_by(&:week)
    @hours_per_week = Hash[records.collect {|week, records| [week, records.inject(0.hours) {|sum, record| sum + 2}]}]

    # hours_per_week = Hash.new
    # current_week= records.first.start_time.week
    # records.each do |r|
    #   if r.start_time.week != current_week
    #     current_week = r.start_time.week
    #   end
    #   hours_per_week = 
  end
end
