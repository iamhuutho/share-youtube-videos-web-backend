require 'rails_helper'

RSpec.describe NotificationController, type: :controller do
  let(:user) { create(:user) }  # Ensure you create a valid user
  let(:notification) { build(:notification) } # Use build instead of create to avoid triggering validations during setup

  before do
    # This will simulate the user being logged in by setting the current_user
    allow(controller).to receive(:current_user).and_return(user)
    allow(user).to receive(:user_sessions).and_return([create(:user_session)]) # Simulate an active session
  end

  describe 'POST #create' do
    it 'creates a new notification' do
      expect {
        post :create, params: { title: notification.title, message: notification.message }
      }.to change(Notification, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it 'renders errors when saving fails' do
      post :create, params: { title: '', message: '' } # Pass invalid params
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET #index' do
    it 'returns notifications' do
      # Create a notification for the user
      create(:notification, user: user, title: 'Sample Notification', message: 'This is a sample notification')

      get :index, params: { username: user.username }

      expect(response).to have_http_status(:ok)
    end
  end
end
