require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_auth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider:'facebook', uid: '123456')}
 
    context 'user already has authorization' do
      it 'returns user'  do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_auth(auth)).to eq user 
      end
    end

    context 'user has no authorization' do
      context 'user already exists'  do
        let(:auth) { OmniAuth::AuthHash.new(provider:'facebook', uid: '123456', info: {email: user.email}) }
        it 'does not create new user' do 
          expect { User.find_for_auth() }.to_not change(User, :count)
        end 

        it 'creates authorization for user' do 
           expect { User.find_for_auth(auth) }.to change(user.authorizations, :count).by(1) 
        end 

        it 'creates authorization with provider and uid' do
          user = User.find_for_auth(auth)
          authorization = user.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end


        it 'returns the user' do
          expect(User.find_for_auth(auth)).to eq user
        end        
      end

      context 'user does not exist' do 
        let(:auth) { OmniAuth::AuthHash.new(provider:'facebook', uid: '123456', info: { email: 'new@user.com' }) }
        it 'creates new user' do 
          expect {User.find_for_auth(auth)}.to change(User, :count).by(1)
        end

        it 'returns new user' do 
          expect(User.find_for_auth(auth)).to be_a(User)
        end

        it 'fills user email' do 
          user = User.find_for_auth(auth)
          expect(user.email).to eq auth.email
        end

        it 'creates authorization for user' do 
          user = User.find_for_auth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do 
          authorization = User.find_for_auth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end

      context 'new user without email' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456', info: {}) }

        it 'does not create new user' do
          expect do
            User.find_for_auth(auth)
          end.not_to change(User, :count)
        end

        it 'returns new user' do
          expect(User.find_for_auth(auth)).to be_a(User)
        end

        it 'does not create authorization for user' do
          user = User.find_for_auth(auth)
          expect(user.authorizations).to be_empty
        end
      end

    end
    
  end
end