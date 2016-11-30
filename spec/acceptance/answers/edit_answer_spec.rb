require 'rails_helper' 

feature 'Editing answer' do
  given!(:user){create(:user)}
  given!(:question){create(:question)}
  given!(:answer){create(:answer, question: question, user: user)}

  describe 'Authenticate user' do

    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'User sees Edit link', js: true do
      within '.answers' do
        expect(page).to have_link "Edit"
      end
    end

    scenario 'User can edit your answer', js: true do 
      click_on 'Edit'
      within '.answers' do     
      fill_in "Edit your answer", with: 'It is my updated answer'
      click_on 'Save'
      expect(page).to_not have_content answer.body
      expect(page).to_not have_selector 'textarea'
      expect(page).to have_content 'It is my updated answer'
      end
      
    end
  
 end
end 