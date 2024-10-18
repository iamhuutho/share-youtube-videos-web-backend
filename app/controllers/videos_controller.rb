class VideosController < ApplicationController

  def create
    authorize_user
    video_sharing_service = VideoSharingService.new(params[:url])
    video = current_user.videos.create(title: params[:title], description: params[:description], url: params[:url], thumbnail_url: video_sharing_service.extract_video_id())
    if video.save
      ActionCable.server.broadcast 'video_channel', {
        video: video.title,
        author: current_user.username
      }
      render json: { message: "Video shared successfully" }, status: :created
    else
      render json: { errors: video.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    videos = Video.all
    render json: videos, status: :ok
  end

  def update
    video = Video.find(params[:id])
    user_interaction = UserVideoInteraction.find_or_initialize_by(user: current_user, video: video)
    case params[:action_type]
    when 'like'
      user_interaction.action = 'like'
      user_interaction.save
      video.increment!(:likes)
    when 'dislike'
      user_interaction.action = 'dislike'
      user_interaction.save
      video.increment!(:dislikes)
    when 'undolike'
      if user_interaction.action == 'like'
        user_interaction.destroy
        video.decrement!(:likes)
      end
    when 'undodislike'
      if user_interaction.action == 'dislike'
        user_interaction.destroy
        video.decrement!(:dislikes)
      end
    else
      render json: { message: "Invalid action" }, status: :unprocessable_entity
      return
    end

    render json: { message: "#{params[:action_type].capitalize} action recorded", likes: video.likes, dislikes: video.dislikes }, status: :ok
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
