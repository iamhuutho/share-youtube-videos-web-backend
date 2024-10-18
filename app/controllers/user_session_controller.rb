class UserSessionController < ApplicationController
  def create
    user = User.find_by(username: params[:username])

    if user&.authenticate(params[:password])
      session_token = SecureRandom.hex(10)
      expires_at = 1.hour.from_now
      session = user.user_sessions.create(user_id: user.id, session_token: session_token, expires_at: expires_at)
      if session.save
        render json: { 
          message: "Logged in successfully", 
          user: { username: user.username }, 
          session_token: session_token 
        }, status: :ok
      else
        render json: { message: "Session could not be created" }, status: :internal_server_error
      end
    else
      render json: { message: "Invalid credentials" }, status: :unauthorized
    end
  end

  def logout
    user = User.find_by(username: params[:username])
    current_session = user.user_sessions.where(revoked: false).last
    if current_session
      current_session.update(revoked: true)
      render json: { message: "Session revoked" }, status: :ok
    else
      render json: { message: "Session not found" }, status: :not_found
    end
  end

end
