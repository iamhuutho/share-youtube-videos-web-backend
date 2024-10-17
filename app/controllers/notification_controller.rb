class NotificationsController < ApplicationController
  before_action :authorize_user

  def index
    @notifications = current_user.notifications
    render json: @notifications
  end

  def update
    @notification = Notification.find(params[:id])
    @notification.update(read: true)
    render json: { message: 'Notification marked as read' }, status: :ok
  end

  private

  def authorize_user
    session = current_user.user_sessions.last
    AuthorizationService.new(session).authorize_user
  rescue AuthorizationError => e
    render json: { error: e.message }, status: :unauthorized
  end
end
