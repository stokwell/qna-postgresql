require 'rails_helper' 

feature 'Streaming question', %q{
  
} do 

given(:user) { create(:user) }
given(:guest) { create(:user) }

context "multiple sessions for question" do

    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('quest') do
        sign_in(quest)
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on('Ask question')
        fill_in('Title', with: 'Test question')
        fill_in('Your question', with: 'body text')
        click_button 'Save'

        expect(page).to have_content 'Test question'
        expect(page).to have_content 'body text'
      end

      Capybara.using_session('quest') do
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'body text'
      end
    end
  end
end