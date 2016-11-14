class Question < ActiveRecord::Base
	validates :body, :title, presence: true
	has_many :answers
end
