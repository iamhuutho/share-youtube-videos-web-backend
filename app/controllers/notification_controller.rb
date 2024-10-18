class NotificationController < ApplicationController
  before_action :authorize_user

  def create
    @notification = current_user.notification.new(notification_params)
    if @notification.save
      VideoChannel.broadcast_to(
        'video_channel',
        { action: 'notify', author: current_user.username, video: @notification.title, user_id: current_user.id }
      )
      render json: @notification, status: :created
    else
      render json: { errors: @notification.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    @notifications = Notification.select(:id, :user_id, :title, :message).where.not(user_id: current_user.id)
    notifications_response = @notifications.map do |notification|
      user_id = User.find_by(username: params[:username]).id
      noti_hist_element = NotificationHistory.find_by(notification_id: notification.id, user_id: user_id, read: true)
      {
        id: notification.id,
        title: notification.title,
        message: notification.message,
        read: noti_hist_element.present?
      }
    end

    render json: notifications_response, status: :ok
  end

  private

  def authorize_user
    session = current_user.user_sessions.last
    AuthorizationService.new(session).authorize_user
  rescue AuthorizationError => e
    render json: { error: e.message }, status: :unauthorized
  end

  def notification_params
    params.permit(:title, :message)
  end

  def current_user
    User.find_by(username: params[:username])
  end
end
