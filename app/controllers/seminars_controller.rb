class SeminarsController < ApplicationController
  
  def new
    @seminar = Seminar.new
    @course = Course.find_by(id: params[:course_id])
  end

  def show 
    @seminar = Seminar.find(params[:id])
    @question = Question.new
    @questions = @seminar.questions
  end

  def create
    @course = Course.find_by(id: params[:course_id])
    @seminar = @course.seminars.build(seminar_params)
    if @seminar.save
      redirect_to '/'
    else
      render :new 
    end  
  end

  def edit
    @seminar = Seminar.find(params[:id])
  end


  def update
    @course = Course.find_by(id: params[:course_id])
    @seminar = Seminar.find(params[:id])
    @seminar.update(seminar_params)
  end


  def destroy
    @seminar = Seminar.find(params[:id])
    @seminar.destroy
  end

  private

  def seminar_params
    params.require(:seminar).permit(:course_id, :theme, :date, :lecture)
  end

end
