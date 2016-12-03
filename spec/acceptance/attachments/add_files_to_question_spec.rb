require 'rails_helper'

feature 'Add files to question' do

  given(:user) {create(:user)}
  given(:another_user){create(:user)}
  given(:question) {create(:question)}

  before do 
    sign_in(user)
    visit new_question_path
    fill_in "Title", with: "Question with attach" 
    fill_in "Body", with: "Question body body"
  end

  
 scenario "User can add several file when asks question", js: true do 
    click_on "Add file"
    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
    inputs[1].set("#{Rails.root}/spec/rails_helper.rb")

    click_on "Create"
    expect(page).to have_link "spec_helper.rb", href: "/uploads/attachment/file/1/spec_helper.rb"
    expect(page).to have_link "rails_helper.rb", href: "/uploads/attachment/file/2/rails_helper.rb"
  end  

  scenario "Author can delete their attached files", js: true do 
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"  
    click_on "Create"

    within ".question" do
      click_on "Delete file"
      expect(page).to_not have_content "spec_helper.rb"
    end
   end
   
  scenario "Only author can destroy their files", js: true do
   
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"  

    click_on "Create"

    click_on "Sign out"
    sign_in(another_user)
    
    visit question_path(question)

    within ".question" do
      expect(page).to_not have_content "Delete file"
    end
  end

end