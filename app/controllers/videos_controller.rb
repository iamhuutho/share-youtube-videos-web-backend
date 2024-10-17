class VideosController < ApplicationController
  before_action :authorize_user

  def create
    video_sharing_service = VideoSharingService.new(params[:thumbnail_url])
    video = current_user.videos.create(title: params[:title], description: params[:description], url: params[:url], thumbnail_url: video_sharing_service.extract_video_id())
    if video.save
      ActionCable.server.broadcast 'video_channel', video: video.title, author: current_user.username
      render json: { message: "Video shared successfully" }, status: :created
    else
      render json: { errors: video.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    videos = Video.all
    render json: videos, status: :ok
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
