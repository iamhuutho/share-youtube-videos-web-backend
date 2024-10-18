require 'rails_helper'

RSpec.describe UserController, type: :controller do
  describe 'POST #create' do
    it 'creates a new user' do
      expect {
        post :create, params: { username: 'new_user', password: 'password' }
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['message']).to eq("User created successfully")
    end

    # it 'renders an error when the session cannot be created' do
    #   allow_any_instance_of(User).to receive(:user_sessions).and_return(double("UserSessions", create: false)) # Simulate session creation failure

    #   post :create, params: { username: 'new_user', password: 'password' }
      
    #   expect(response).to have_http_status(:internal_server_error)
    #   expect(JSON.parse(response.body)['message']).to eq("Session could not be created")
    # end

    it 'renders errors when saving the user fails' do
      post :create, params: { username: '', password: '' } # Invalid parameters
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include("Username can't be blank", "Password can't be blank") # Adjust based on your validations
    end
  end

  describe 'GET #show' do
    it 'shows the user' do
      user = create(:user)
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['username']).to eq(user.username) # Check the username returned
    end

    it 'renders not found when user does not exist' do
      get :show, params: { id: 99999 } # An ID that does not exist
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq("User not found")
    end
  end
end
