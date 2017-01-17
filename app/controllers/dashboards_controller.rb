class DashboardsController < ApplicationController
  def index
    @users_questions = current_user.questions.all
    @users_answers = current_user.answers.all
    @users_comments = current_user.comments.all
  end
end
