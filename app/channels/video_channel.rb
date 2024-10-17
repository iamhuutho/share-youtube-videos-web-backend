class VideoChannel < ApplicationCable::Channel
  def subscribed
    stream_from "video_channel"
  end

  def like_video(data)
    ActionCable.server.broadcast 'video_channel', action: 'like', video_id: data['video_id']
  end

  def dislike_video(data)
    ActionCable.server.broadcast 'video_channel', action: 'dislike', video_id: data['video_id']
  end

  def video_shared(data)
    notification = Notification.create(
      title: "New Video Shared",
      message: "#{data['author']} shared a new video: #{data['video']}",
      user_id: data['user_id'], # This should be the ID of the user who shared the video
    )
    
    ActionCable.server.broadcast 'video_channel', {
      action: 'notify',
      notification: {
        id: notification.id,
        title: notification.title,
        message: notification.message,
        read: notification.read
      }
    }
  end
  
  def unsubscribed
    stop_all_streams
  end
end
