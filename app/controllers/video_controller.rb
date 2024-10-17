class VideosController < ApplicationController
  before_action :authorize_user

  def create
    video = current_user.videos.new(video_params)
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

  def video_params
    params.require(:video).permit(:title, :description, :url, :thumbnail_url)
  end
end
