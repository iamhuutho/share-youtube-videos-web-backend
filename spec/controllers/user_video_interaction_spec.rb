require 'rails_helper'

RSpec.describe UserVideoInteractionController, type: :controller do
  let(:user) { create(:user) } 
  let(:video) { create(:video, user: user) } 

  before do
    # Simulate the user session for authorization
    allow_any_instance_of(described_class).to receive(:current_user).and_return(user)
    allow(user).to receive(:user_sessions).and_return([create(:user_session)]) # Ensure there's an active session
  end

  describe 'GET #get_interaction' do
    context 'when the user has interacted with the video' do
      it 'returns user interaction with the video' do
        interaction = UserVideoInteraction.create(user: user, video: video, action: 'like')
        
        get :get_interaction, params: { video_id: video.id, username: user.username }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['liked']).to eq('like')
      end
    end

    context 'when the user has not interacted with the video' do
      it 'returns nil for interaction' do
        get :get_interaction, params: { video_id: video.id, username: user.username }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['liked']).to be_nil
      end
    end
  end
end
