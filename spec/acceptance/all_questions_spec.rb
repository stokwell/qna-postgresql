require 'rails_helper' 

feature 'See all questions', %q{
  In order to see all questions
  As an user 
  I want to be able to show a list of all questions
} do 

given!(:questions) { create_list(:question, 3) }

scenario 'A user tries to see a list of all questions'  do 
     
     visit questions_path
   
     questions.each do |question|
        expect(page).to have_content(question.title)
     end

  end  
   
end