require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

   let(:user)  { create(:user) }
   let!(:question) { create(:question) }
   let(:answer)   { create(:answer, question: question, user: @user)}

  context 'guest user' do
    describe 'GET #new' do
      before { get :new, question_id: question.id } 

      it 'redirects to login page' do
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'POST #create' do
      let(:answer_params) { { answer: attributes_for(:answer), question_id: question } }

      it 'redirects to login page' do
        post :create, answer_params
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not create new answer in database' do
        expect do
          post :create, answer_params
        end.not_to change(Answer, :count)
      end
    end

    describe 'DELETE #destroy' do
      let!(:answer) { create(:answer) }

      it 'redirects to login page' do
        delete :destroy, id: answer.id, question_id: answer.question.id 
        expect(response).to redirect_to new_user_session_path
      end

      it 'does not create new answer in database' do
        expect do
          delete :destroy, id: answer.id, question_id: answer.question.id 
        end.not_to change(Answer, :count)
      end
    end
  end


  context 'authenticated user' do
    sign_in_user

    describe 'GET #new' do
      before { get :new,  question_id: question.id } 

      it 'renders new view' do
        expect(response).to render_template(:new)
      end

      it 'assigns new answer model @answer' do
        expect(assigns(:answer)).to be_a_new(Answer)
      end
    end

    describe 'POST #create' do
      context 'valid answer' do
        let(:answer_params) { { answer: attributes_for(:answer), question_id: question, format: :js  } }

        it 'creates answer in database' do
          expect do
            post :create, answer_params
          end.to change(question.answers, :count).by(1)
        end

        it 'creates answer owned by current user' do
          post :create, answer_params
          expect(Answer.last.user_id).to eq(@user.id)
        end

        it 'renders create template' do
          post :create, answer_params
          expect(response).to render_template :create
        end
      end

      context 'invalid answer' do
        let(:answer_params) { { answer: attributes_for(:invalid_answer), question_id: question, format: :js  } }

        it 'does not create answer in database' do
          expect do
            post :create, answer_params
          end.not_to change(Answer, :count)
        end

        it 'renders create template' do
          post :create, answer_params
          expect(response).to render_template :create
        end
      end
    end

    describe 'PATCH #update' do
      
    
      it 'update answer with valid attributes' do
       patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
       expect(assigns(:answer)).to eq answer
      end

      it 'exactly update answer' do
        patch :update, id: answer, question_id: question, answer: {body: 'new bodynew body'}, format: :js
        answer.reload
        expect(answer.body).to eq 'new bodynew body' 
        expect(answer.user.id).to eq @user.id
      end

      it 'render to update template' do 
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :update
      end
  end

    describe 'DELETE #destroy' do
      context 'own answer' do
        let!(:answer) { create(:answer, user: @user) }

        it 'renders destroy temlpate' do
          delete :destroy,  id: answer.id, question_id: answer.question.id, format: :js 
          expect(response).to render_template :destroy
         
        end

        it 'deletes answer in database' do
          expect do
            delete :destroy, id: answer.id, question_id: answer.question.id, format: :js  
          end.to change(Answer, :count).by(-1)
        end
      end

      context 'other user\'s answer' do
        let!(:answer) { create(:answer) }


        it 'does not delete answer in database' do
          expect do
            delete :destroy,  id: answer.id, question_id: answer.question.id, format: :js 
          end.not_to change(Answer, :count)
        end
      end
    end
    
     describe 'PATCH #best' do 

     context "When user question's author" do 

      let!(:question_user) { create(:question, user: user) }
      let!(:answer)   { create(:answer, question: question_user)}
      
      before do
       sign_in(user)
        patch :best,  id: answer, format: :js
      end
      
      it "Question's author can select best answer" do 
        answer.reload
        expect(answer.best_answer).to eq true
      end

      it "Render template :best" do
        expect(response).to render_template :best
      end

      it "Question's author can select best another answer" do
        answer.reload
        expect(answer.best_answer).to eq true

        answer_next = create(:answer, question: question_user)
        patch :best,  id: answer_next, format: :js
        answer.reload
        answer_next.reload

        expect(answer.best_answer).to eq false
        expect(answer_next.best_answer).to eq true
      end
    end

    context "When user non question's author" do 
   
      let!(:question) { create(:question, user: user) }
      let!(:answer)   { create(:answer, question: question)}
      sign_in_user

      it "try to select best answer" do 
        patch :best,  id: answer, format: :js
        answer.reload
        expect(answer.best_answer).to eq false
      end
    end
  end


  end
end



