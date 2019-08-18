class Api::V1::UsersController < ApplicationController
  before_action :get_user, only: [:show, :update, :destroy]

  def index
    @users = User.all
    render json: @users
  end

  def show
    render json: @user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @token = JWT.encode({user_id: @user.id}, "secret")
      render json: {user: @user, jwt: @token}, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    render json: @user
    @user.destroy
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end

  def get_user
    @user = User.find(params[:id])
  end
end
