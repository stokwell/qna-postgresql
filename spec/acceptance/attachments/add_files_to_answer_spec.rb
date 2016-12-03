require 'rails_helper'

feature 'Add files to answer' do

  given(:user) {create(:user)}
  given(:question) {create(:question)}
  given(:another_user){create(:user)}
  

  before do 
    sign_in(user)
    visit question_path(question)
    
  end

  scenario "User can add files when gives answer", js: true do 
    find("#clear").set "answer text"
    
    click_on "Add file"
    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
    inputs[1].set("#{Rails.root}/spec/rails_helper.rb")
    click_on "Add an answer"
    
    within '.answers' do
      expect(page).to have_link "spec_helper.rb", href: "/uploads/attachment/file/1/spec_helper.rb"
      expect(page).to have_link "rails_helper.rb", href: "/uploads/attachment/file/2/rails_helper.rb"
    end
  end

   scenario "Author can delete their attached files", js: true do 
    find("#clear").set "answer text"

    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"  
    click_on "Add an answer"
    within "#answer-1" do
      click_on "Delete file"
      expect(page).to_not have_content "spec_helper.rb"
    end
  end

  scenario "Only author can destroy their files", js: true do
    find("#clear").set "answer text"

    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"  
    click_on "Add an answer"
    expect(page).to have_content "Delete file"

    click_on "Sign out"
   
    sign_in(another_user)   
    visit question_path(question)
    within "#answer-1" do
      expect(page).to_not have_content "Delete file"
     end
  end

end