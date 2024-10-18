class NotificationHistoryController < ApplicationController
  before_action :authorize_user
  
  def create
    notification = Notification.find(params[:notification_id])
    @notification_hist = NotificationHistory.new(notification: notification, user: current_user, read: true)
    
    if @notification_hist.save      
      render json: {message: "ok"}, status: :created
    else
      render json: { errors: @notification.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    notification_history = current_user.find_by(notification_id: params[:notification_id])

    if notification_history.update(read: true)
      render json: { message: "Notification marked as read" }, status: :ok
    else
      render json: { errors: notification_history.errors.full_messages }, status: :unprocessable_entity
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
