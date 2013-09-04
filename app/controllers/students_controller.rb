class StudentsController < ApplicationController

  def index
    @students = Student.includes(:records)
    @student_records = Hash[@students.collect {|student| [student, student.hours_per_week]}]
    @weeks =  @student_records.values.collect {|records| records.keys}.flatten.uniq.sort
  end

  def show
    @student = Student.includes(:comments).find(params[:id])
    @hours_per_week = @student.hours_per_week
  end
end
