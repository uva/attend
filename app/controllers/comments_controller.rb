class CommentsController < ApplicationController
  before_action :set_student, only: [:create, :new, :index]

  prepend_before_filter CASClient::Frameworks::Rails::Filter
  before_filter :is_assistant?

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html {
          flash[:notice] = 'Comment was successfully created.' 
          redirect_to :root 
        }
        format.json { render action: 'show', status: :created, location: @comment }
      else
        format.html { render action: 'new' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def index
    @comments = @student.comments.includes(:author)
  end

  def feed
    @comments = Comment.all
  end

  private
    def set_student
      @student = Student.find_by(id: params[:student_id])
    end

    def comment_params
      params[:comment].permit(:body).merge(student_id: @student.id, author_id: current_user.id)
    end
end
