class Question < ApplicationRecord
  
  include Votable

  validates :title, presence: true
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user
  belongs_to :seminar

  accepts_nested_attributes_for :attachments, :reject_if => :all_blank, :allow_destroy => true
  
  
end
