class StudentsController < ApplicationController

  prepend_before_filter CASClient::Frameworks::Rails::Filter
  before_filter :is_assistant?, except: [:import, :do_import]
  before_filter :is_admin?, only: [:import, :do_import]

  def index
    @students = Student.includes(:records)
    @student_records = Hash[@students.collect {|student| [student, student.hours_per_week]}]
    @weeks =  @student_records.values.collect {|records| records.keys}.flatten.uniq.sort
  end

  def show
    @student = Student.includes(:comments).find(params[:id])
    @hours_per_week = @student.hours_per_week
  end

  def import
    require 'json'
    require 'open-uri'

    authentication = [ENV['IMPORT_USERNAME'], ENV['IMPORT_PASSWORD']]
    students = JSON.parse(open(ENV['IMPORT_URL'], http_basic_authentication: authentication).read)

    students.each do |student|
      record = Student.find_or_create_by(student_id: student['student_id'])
      record.name = student['name']
      record.save
    end

    redirect_to :root
  end
end
