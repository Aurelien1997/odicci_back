require 'uri'
require 'net/http'
require 'openssl'
class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]

  # GET /users
  def index
    @users = User.all

    render json: @users

  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end

    url = URI("https://a.klaviyo.com/api/profiles/")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    
    request = Net::HTTP::Post.new(url)
    request["accept"] = 'application/json'
    request["revision"] = '2022-10-17'
    request["content-type"] = 'application/json'
    request["Authorization"] = 'Klaviyo-API-Keypk_30b721cc9db35ff594caff64c0984311fc'
    request.body = "{\"data\":{\"type\":\"profile\",\"attributes\":{\"email\":\"#{@user.email}\",\"first_name\":\"#{@user.first_name}\",\"last_name\":\"#{@user.last_name}\"}}}"
    
    
    response = http.request(request)
    puts response.read_body
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :phone, :birth)
    end
end
