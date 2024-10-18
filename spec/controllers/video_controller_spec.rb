require 'rails_helper'

RSpec.describe VideosController, type: :controller do
  let(:user) { create(:user) } # Create a user for association
  let(:video_params) { { title: 'Test Video', description: 'Test Description', url: 'http://example.com/video' } }
  let!(:video) { create(:video, user: user) } # Create a video associated with the user for use in update tests

  before do
    # Simulate the user session for authorization
    allow_any_instance_of(described_class).to receive(:current_user).and_return(user)
    allow(user).to receive(:user_sessions).and_return([create(:user_session)]) # Ensure there's an active session
  end

  describe 'POST #create' do  
    it 'renders errors when video creation fails' do
      post :create, params: video_params.merge(title: '') # Title is blank to trigger validation error
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to include("Title can't be blank") # Adjust based on your validations
    end
  end

  describe 'GET #index' do
    it 'returns all videos' do
      create(:video, user: user, title: 'Existing Video', description: 'An existing video description', url: 'http://example.com/existing_video') # Use factory for existing video
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(2) # Adjust based on number of videos created
      expect(JSON.parse(response.body).last['title']).to eq('Existing Video')
    end
  end

  describe 'PUT #update' do
    context 'when liking a video' do
      it 'increments likes count' do
        put :update, params: { action_type: 'like', id: video.id }
        expect(video.reload.likes).to eq(1)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when disliking a video' do
      it 'increments dislikes count' do
        put :update, params: { action_type: 'dislike', id: video.id }
        expect(video.reload.dislikes).to eq(1)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when changing to like from dislike' do
      it 'changes action from dislike to like' do
        # Simulate the user disliking the video first
        UserVideoInteraction.create(user: user, video: video, action: 'dislike')
        
        put :update, params: { action_type: 'change_to_like', id: video.id }
        expect(video.reload.likes).to eq(1)
        expect(video.reload.dislikes).to eq(-1)
        expect(UserVideoInteraction.find_by(user: user, video: video).action).to eq('like')
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when changing to dislike from like' do
      it 'changes action from like to dislike' do
        # Simulate the user liking the video first
        UserVideoInteraction.create(user: user, video: video, action: 'like')
        
        put :update, params: { action_type: 'change_to_dislike', id: video.id }
        expect(video.reload.dislikes).to eq(1)
        expect(video.reload.likes).to eq(-1)
        expect(UserVideoInteraction.find_by(user: user, video: video).action).to eq('dislike')
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when undoing a like' do
      it 'decreases likes count' do
        user_video_interaction = UserVideoInteraction.create(user: user, video: video, action: 'like')
        put :update, params: { action_type: 'undolike', id: video.id }
        expect(video.reload.likes).to eq(-1)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when undoing a dislike' do
      it 'decreases dislikes count' do
        user_video_interaction = UserVideoInteraction.create(user: user, video: video, action: 'dislike')
        put :update, params: { action_type: 'undodislike', id: video.id }
        expect(video.reload.dislikes).to eq(-1)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when an invalid action is provided' do
      it 'returns an error' do
        put :update, params: { action_type: 'invalid_action', id: video.id }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to eq("Invalid action")
      end
    end
  end
end
