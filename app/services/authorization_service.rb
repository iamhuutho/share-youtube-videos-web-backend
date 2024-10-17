class AuthorizationService
  def initialize(session)
    @session = session
  end

  def authorize_user
    valid_token
  end

  private

  def valid_token
    @session.expires_at > Time.now
  end

end

class AuthorizationError < StandardError; end
