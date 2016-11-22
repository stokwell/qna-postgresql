require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  context 'public' do 
    describe 'GET #index' do

    let(:questions) { create_list(:question, 2) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }

    before { get :show, id: question }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end
end

  context 'guest user' do
    
    describe 'GET #new' do
      before { get :new }

      it 'redirects to login page' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'POST #create' do
      it 'redirects to login page' do
        post :create,  question: attributes_for(:question) 
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not create new question in database' do
        expect do
          post :create,  question: attributes_for(:question) 
        end.not_to change(Question, :count)
      end
    end

    describe 'DELETE #destroy' do
      let!(:question) { create(:question) }

      it 'redirects to login page' do
        delete :destroy,  id: question.id 
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not create new question in database' do
        expect do
          delete :destroy,  id: question.id 
        end.not_to change(Question, :count)
      end
    end
end


  context 'authenticated user' do
    sign_in_user

    describe 'GET #new' do
      before { get :new }

      it 'renders new view' do
        expect(response).to render_template(:new)
      end

      it 'assigns new question model @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end
    end

    describe 'POST #create' do
      context 'valid question' do
        it 'creates new question in database' do
          expect do
            post :create,  question: attributes_for(:question) 
          end.to change(Question, :count).by(1)
        end

        it 'creates answer owned by current user' do
          post :create,  question: attributes_for(:question) 
          expect(Question.last.user_id).to eq(@user.id)
        end

        it 'redirects to questions list' do
          post :create,  question: attributes_for(:question) 
          expect(response).to redirect_to questions_path
        end
      end

      context 'invalid question' do
        it 'does not create new question in database' do
          expect do
            post :create,  question: attributes_for(:invalid_question) 
          end.not_to change(Question, :count)
        end

        it 'renders new view' do
          post :create,  question: attributes_for(:invalid_question) 
          expect(response).to render_template(:new)
        end
      end
end
   
  describe 'DELETE #destroy' do

      context 'own question' do
        let!(:question) { create(:question, user: @user) }

        it 'deletes question in database' do
          expect do
            delete :destroy, id: question.id 
          end.to change(Question, :count).by(-1)
        end 

        it 'redirects to question list' do
          delete :destroy, id: question.id 
          expect(response).to redirect_to questions_path
        end
      end

       context 'other user question' do
        let!(:question) { create(:question) }

        it 'redirects to question page' do
          delete :destroy,  id: question.id 
          expect(response).to redirect_to question_path
          expect(flash[:alert]).to eq('Not allowed.')
        end

        it 'does not delete question in database' do
          expect do
            delete :destroy,  id: question.id 
          end.not_to change(Question, :count)
    end
  end
end

end

end
