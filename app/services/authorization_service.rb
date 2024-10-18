class AuthorizationService
  def initialize(session)
    @session = session
  end

  def authorize_user
    return true if valid_token
    raise AuthorizationError, "Session has expired"
  end

  private

  def valid_token
    @session.expires_at > Time.current
  end
end

class AuthorizationError < StandardError; end
