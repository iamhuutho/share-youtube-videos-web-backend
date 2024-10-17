class UserController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      session_token = SecureRandom.hex(10)
      expires_at = 1.hour.from_now
      session = user.user_sessions.create(user_id: user.id, session_token: session_token, expires_at: expires_at)
      if session.save
      else
        render json: { message: "Session could not be created" }, status: :internal_server_error
        return
      end
      render json: { message: "User created successfully" }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    user = User.find(params[:id])
    render json: user, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end

  private

  def user_params
    params.permit(:username, :password)
  end
end
