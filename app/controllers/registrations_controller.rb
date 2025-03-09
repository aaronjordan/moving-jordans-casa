class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]

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

    if verify_recaptcha(model: @user) && @user.save
      start_new_session_for @user
      redirect_to root_path, notice: "Successfully signed up!"
    else
      render :new
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


  private

  def user_params
    params.require(:user).permit(:email_address,
      :password, :password_confirmation, :display_name)
  end
end
