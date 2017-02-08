class Seminar < ApplicationRecord
  validates :theme, presence: true
  validates :date, presence: true
  belongs_to :course
  has_many :questions, dependent: :destroy

  def count_questions
    self.questions.count
  end
end
