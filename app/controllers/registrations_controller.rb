class RegistrationsController < ApplicationController
  rescue_from RailsCloudflareTurnstile::Forbidden, with: :validate_failed_error
  allow_unauthenticated_access only: %i[ new create ]
  before_action :validate_cloudflare_turnstile, only: %i[create]

  def index
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    unless User.where(email_address: @user.email_address).empty?
      flash[:alert] = "Email is already registered."
      render :new, status: :bad_request
      return
    end

    if @user.save
      start_new_session_for @user
      redirect_to root_path, notice: "Successfully signed up!"
    else
      flash[:alert] = "Could not validate ReCaptcha"
      render :new, status: :bad_request
    end
  end

  def edit
    @user = Current.user
  end

  def update
    @user = Current.user
    if @user.update(user_params)
      flash[:success] = "User was successfully updated"
      redirect_to root_path
    else
      flash[:alert] = "Something went wrong"
      render "edit"
    end
  end

  def validate_failed_error
    flash[:alert] = "Could not validate Cloudflare Turnstile"
    render :new, status: :bad_request
  end

  private

  def user_params
    params.require(:user).permit(:email_address,
      :password, :password_confirmation, :display_name)
  end
end
