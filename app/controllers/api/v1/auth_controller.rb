class Api::V1::AuthController < ApplicationController
  def show
    user_id = JWT.decode(request.headers["Authorization"], nil, false)[0]["user_id"]
    user = User.find(user_id)
    render json: {user: user}
  end

  def create
    @user = User.find_by(email: login_params[:email])
    if @user && @user.authenticate(login_params[:password])
      token = JWT.encode({user_id: @user.id}, "secret")
      render json: {user: @user, jwt: token}, status: :accepted
    else
      render json: {message: 'Invalid username or password'}, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
