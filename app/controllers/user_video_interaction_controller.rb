class UserVideoInteractionController < ApplicationController
  before_action :authorize_user

  def get_interaction
    interaction = UserVideoInteraction.find_by(user_id: current_user.id, video_id: params[:video_id])

    if interaction
      render json: { liked: interaction.action }, status: :ok
    else
      render json: { liked: nil }, status: :not_found
    end
  end

  private

  def authorize_user
    session = current_user.user_sessions.last
    AuthorizationService.new(session).authorize_user
  rescue AuthorizationError => e
    render json: { error: e.message }, status: :unauthorized
  end

  def current_user
    User.find_by(username: params[:username])
  end
end
