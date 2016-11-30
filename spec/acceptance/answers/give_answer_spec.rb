require 'rails_helper' 

feature 'Give an answer', %q{
  In order to be able to give an answer
  As an user 
  I want to be able to add an answer to a question
} do 
  
  given(:user) { create(:user) } 
  given!(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  scenario 'Registered user tries to give an answer', js: true  do
    sign_in(user) 

    visit question_path(question)
    fill_in 'Body', with: answer[:body]
    click_on 'Add an answer'
    
    expect(current_path).to eq question_path(id: question.id)
    within ".answers" do
      expect(page).to have_content(answer[:body])
    end
  end 

  scenario 'User try to create empty answer', js: true do
    sign_in(user)

    visit question_path(question)
    click_on 'Add an answer'
    page.has_content? "Body can't be blank"

end

  scenario 'Non-registered user tries to give an answer' do 
    visit question_path(question)
    click_on 'Add an answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing.' 
  end

end