class CommentsController < ApplicationController

  prepend_before_filter CASClient::Frameworks::Rails::Filter
  before_filter :is_authorized?

  def new
    @comment = Comment.new
    @student = current_student
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

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def current_student
      @student = Student.find_by(params[:student_id])
    end

    def comment_params
      params[:comment].permit(:body).merge(student_id: current_student.id, author_id: current_user.id)
    end
end
