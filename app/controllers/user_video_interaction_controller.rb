class UserVideoInteractionController < ApplicationController
  before_action :authorize_user

  def show
    interaction = UserVideoInteraction.find_by(user_id: current_user.id, video_id: params[:video_id])
    
    if interaction
      render json: { liked: interaction.liked, disliked: interaction.disliked }, status: :ok
    else
      render json: { liked: false, disliked: false }, status: :ok
    end
  end

  private

  def authorize_user
    byebug
    session = current_user.user_sessions.last
    AuthorizationService.new(session).authorize_user
  rescue AuthorizationError => e
    render json: { error: e.message }, status: :unauthorized
  end

  def current_user
    User.find_by(username: params[:username])
  end
end
