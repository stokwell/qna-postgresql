class Question < ActiveRecord::Base
  validates :body, :title, presence: true
  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy
  belongs_to :user
end
