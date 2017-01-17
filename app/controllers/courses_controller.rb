class CoursesController < ApplicationController
  before_action :authenticate_user!,  except: [:index, :show]

  def index
    @courses = Course.all
  end

  def show 
    @course = Course.find(params[:id])
    @seminars = @course.seminars
    @seminar = Seminar.new
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    @course.user = current_user 
    if @course.save
      redirect_to new_course_seminar_path(@course)
    else
      render :new 
    end  
  end

  def enroll
    @course = Course.find(params[:id])
    @course.user = current_user
  end

  private 

  def course_params
    params.require(:course).permit(:theme, :description, :instructor)
  end

end
