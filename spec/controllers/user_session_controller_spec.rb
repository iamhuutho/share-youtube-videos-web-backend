require 'rails_helper'

RSpec.describe UserSessionController, type: :controller do
  let(:user) { create(:user, password: 'password') } # Ensure you create the user with a password
  let!(:user_session) { create(:user_session, user: user, revoked: false) } # Create an initial session for testing

  describe 'POST #create' do
    context 'with valid credentials' do
      it 'logs in a user successfully' do
        post :create, params: { username: user.username, password: 'password' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq("Logged in successfully")
      end
    end

    context 'with invalid credentials' do
      it 'renders unauthorized when credentials are invalid' do
        post :create, params: { username: user.username, password: 'wrongpassword' }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['message']).to eq("Invalid credentials")
      end
    end

    context 'when session cannot be created' do
      it 'renders internal server error' do
        allow_any_instance_of(UserSession).to receive(:save).and_return(false) # Simulate session creation failure
        post :create, params: { username: user.username, password: 'password' }
        expect(response).to have_http_status(:internal_server_error)
        expect(JSON.parse(response.body)['message']).to eq("Session could not be created")
      end
    end
  end

  describe 'POST #logout' do
    context 'when the user has an active session' do
      it 'logs out the user successfully' do
        delete :logout, params: { username: user.username }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq("Session revoked")
      end
    end

    context 'when no active session is found' do
      it 'renders not found' do
        # Revoke the session to simulate no active session
        user_session.update(revoked: true)
        delete :logout, params: { username: user.username }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['message']).to eq("Session not found")
      end
    end
  end
end
