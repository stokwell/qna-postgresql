class Answer < ActiveRecord::Base
	validates :body, :title, presence: true
	belongs_to :question
end
