require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { question = create(:question) }

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

    describe 'DELETE #destroy' do
      context 'own answer' do
        let!(:answer) { create(:answer, user: @user) }

        it 'redirects to question page' do
          delete :destroy,  id: answer.id, question_id: answer.question.id 
          expect(response).to redirect_to(question_path(answer.question))
          expect(flash[:notice]).to eq('Answer is deleted.')
        end

        it 'deletes answer in database' do
          expect do
            delete :destroy, id: answer.id, question_id: answer.question.id 
          end.to change(Answer, :count).by(-1)
        end
      end

      context 'other user\'s answer' do
        let!(:answer) { create(:answer) }

        it 'redirects to question page' do
          delete :destroy,  id: answer.id, question_id: answer.question.id 
          expect(response).to redirect_to(question_path(answer.question))
          expect(flash[:alert]).to eq('Not allowed.')
        end

        it 'does not delete answer in database' do
          expect do
            delete :destroy,  id: answer.id, question_id: answer.question.id 
          end.not_to change(Answer, :count)
        end
      end
    end
  end
end



