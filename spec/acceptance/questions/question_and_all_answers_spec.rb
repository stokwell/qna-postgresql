require 'rails_helper' 

feature 'See a question and all answers to a question', %q{
  In order to be able to see all answers to a question
  As an user 
  I want to be able to show to user all answers
} do 
  
  given!(:question) { create(:question_with_answers) }

  scenario 'An user tries to see a question and all answers to a question'  do
     visit question_path(question)

     expect(page).to have_content(question.title)
     expect(page).to have_content(question.body)
     question.answers.each do |answer|
       expect(page).to have_content(answer.body)
     end
  end
end 