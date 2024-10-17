class SessionsController < ApplicationController
  def create
    user = User.find_by(username: params[:username])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      render json: { message: "Logged in successfully" }, status: :ok
    else
      render json: { message: "Invalid credentials" }, status: :unauthorized
    end
  end
end
