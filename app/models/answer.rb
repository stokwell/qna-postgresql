class Answer < ActiveRecord::Base
  validates :body, presence: true
  belongs_to :question
  belongs_to :user

  default_scope { order('best_answer DESC') }

  def best
    ActiveRecord::Base.transaction do
      self.question.answers.update_all(best_answer: false)
      self.update(best_answer: true)
    end
  end

end
