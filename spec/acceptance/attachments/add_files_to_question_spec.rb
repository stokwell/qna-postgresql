require 'rails_helper'

feature 'Add files to question' do

  given(:user) {create(:user)}

  before do 
    sign_in(user)
    visit new_question_path
  end

  scenario "User can add files when asks question" do 
    fill_in "Title", with: "Question with attach" 
    fill_in "Body", with: "Question body body"
    attach_file "File", "#{Rails.root}/spec/spec_helper.rb"
    click_on "Create"

    expect(page).to have_link "spec_helper.rb", href: "/uploads/attachment/file/1/spec_helper.rb"
  end

end