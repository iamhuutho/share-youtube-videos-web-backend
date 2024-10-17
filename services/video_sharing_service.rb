class VideoSharingService
  def self.share_video(video)
    video.update!(shared: true)
  end

  def self.unshare_video(video)
    video.update!(shared: false)
  end
end