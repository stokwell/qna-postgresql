require 'rails_helper' 

feature 'Editing qbestion' do
  given!(:user){create(:user)}
  given!(:question){create(:question, user: user)}

  describe 'Authenticate user' do
    
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'User sees Edit link', js: true do
      within '.question' do
        expect(page).to have_link "Edit"
      end
    end

    scenario 'User can edit your answer', js: true do 
      click_on 'Edit'
      within '.question' do     
        fill_in 'Body', with: 'It is my updated question'
        click_on 'Save'
        expect(page).to_not have_content question.body
        expect(page).to_not have_selector 'textarea'
       expect(page).to have_content 'It is my updated question'
      end
      
    end
  
 end
end 