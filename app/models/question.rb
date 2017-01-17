class Question < ActiveRecord::Base
  
  include Votable

  validates :body, :title, presence: true
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :attachments, :reject_if => :all_blank, :allow_destroy => true
  
  
end
