class Course < ApplicationRecord
  validates :theme, presence: true
  validates :instructor, presence: true
  belongs_to :user
  has_many :seminars, dependent: :destroy
end
