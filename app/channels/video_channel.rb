class VideoChannel < ApplicationCable::Channel
  def subscribed
    # Subscribe to the videos_channel when a user connects
    stream_from "video_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed, such as stopping a stream
    stop_all_streams
  end
end
