require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

    describe "DELETE #destroy" do 

    sign_in_user

    let(:user){create(:user)}
    let(:question){create(:question, user: @user)}
    let!(:attach){create(:attachment, attachable: question)}
    
    
    context "Author answer or question can" do 
      it "delete their attachment" do
        expect {delete :destroy, id: attach, format: :js}.to change(Attachment, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, id: attach, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "Non author" do
      let(:a_user){create(:user)}
      it "try delete other attach" do 
      sign_in(a_user)
        expect {delete :destroy, id: attach, format: :js}.to_not change(Attachment, :count)
      end

    end

  end

end
