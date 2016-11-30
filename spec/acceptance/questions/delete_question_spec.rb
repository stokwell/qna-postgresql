require 'rails_helper'

feature 'User deletes his question', '
  As an aunthenticated user
  I want to be able to delete my question and unable to delete other users question
' do

  given(:user) { create(:user) }
  given!(:another_question) { create(:question) }
  given!(:user_question) { create(:question, user: user) }

  scenario 'Authenticated user can delete his question' do
    sign_in(user)
    visit question_path(id: user_question.id)
    click_on 'Delete'

    expect(current_path).to eq questions_path
    expect(page).not_to have_content(user_question.title)
  end

  scenario 'Unautheticated user cannot delete question' do
    visit question_path(id: another_question.id)
    expect(page).not_to have_button('Delete')
 end

  scenario "Authenticated user can't delete someone else's question" do
    sign_in(user)
    visit question_path(id: another_question.id)

    expect(page).not_to have_content('Delete')
  end
end