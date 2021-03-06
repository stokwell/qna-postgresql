class Answer < ApplicationRecord
  include Votable

  validates :body, presence: true
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  accepts_nested_attributes_for :attachments, :reject_if => :all_blank, :allow_destroy => true

  default_scope { order('best_answer DESC') }

  def best
    ActiveRecord::Base.transaction do
      self.question.answers.update_all(best_answer: false)
      self.update!(best_answer: true)
    end
  end

  def count_comments
    self.comments.count
  end

end
