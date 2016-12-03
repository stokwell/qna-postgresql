require 'rails_helper' 

feature 'Create question', %q{
  In order to ask a question to community
  As an authenticated user 
  I want to be able to ask questions
} do 

given(:user) { create(:user) }
given!(:question) { attributes_for(:question) }

scenario 'Authenticated user creates a question' do 

    sign_in(user)

    visit questions_path
    click_on '?Ask'
    fill_in 'Title', with: question[:title]
    fill_in 'Body', with: question[:body]
    click_on 'Create'
    
    expect(page).to have_content "Your question successfully created."
    expect(page).to have_content(question[:title])
end

scenario 'Non-autentithicated user tries to create a question' do
    visit questions_path
    click_on '?Ask'

    expect(page).to have_content "You need to sign in or sign up before continuing."
end

end