class NotificationController < ApplicationController
  before_action :authorize_user

  def create
    @video = current_user.notification.new(notification_params)
    if @video.save
      VideoChannel.broadcast_to(
        'video_channel',
        { action: 'notify', author: current_user.username, video: @video.title, user_id: current_user.id }
      )
      render json: @video, status: :created
    else
      render json: { errors: @video.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    @notifications = current_user.notification
    byebug
    render json: @notification
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

  def notification_params
    params.permit(:title, :message)
  end

  def current_user
    User.find_by(username: params[:username])
  end
end
