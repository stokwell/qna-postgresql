require 'rails_helper'

feature 'User sign out', %q{
  In order to be able to sign out
  As an user
  I want to add sign out functionality
} do

  given(:user) { create(:user) }
  
  
  scenario 'User tries to sign out' do 
     sign_in(user)
     click_on 'Sign out'
     expect(page).to have_content('Signed out successfully.')
  end


end