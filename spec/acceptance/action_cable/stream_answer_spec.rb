require 'rails_helper' 

feature 'Streaming answer', %q{
  
} do 

given(:user) { create(:user) }
given(:guest) { create(:user) }
given(:question) { create(:question, user: user) }

  context "multiple sessions for answer" do
    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('quest') do
        sign_in(quest)
        visit question_path(question)
      end

      Capybara.using_session('user') do
    
        fill_in('Body', with: 'body text')
        click_button 'Save'
        expect(page).to have_content 'body text'
      end

      Capybara.using_session('quest') do
        expect(page).to have_content 'body text'
      end
    end
  end
end