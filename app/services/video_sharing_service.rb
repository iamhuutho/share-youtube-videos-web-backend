class VideoSharingService
  def initialize(url)
    @url = url
  end

  def extract_video_id
    if !check_unique_video_id
      return nil
    end
    return nil if @url.nil? || @url.empty?
    pattern = %r{(?:https?://)?(?:www\.)?(?:youtube\.com/watch\?v=|youtu\.be/|youtube\.com/embed/)(?<video_id>[^&]+)}
    if match = @url.match(pattern)
      return match[:video_id]
    else
      return nil
    end
  end

  private

  def check_unique_video_id
    Video.find_by(url: @url).nil?
  end
end