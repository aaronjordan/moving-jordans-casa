class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def protected_view
    unless is_user_admin?
      redirect_to root_path
    end
  end

  def protected_action
    unless is_user_admin?
      render plain: "not allowed for this user", status: :forbidden
    end
  end
end
