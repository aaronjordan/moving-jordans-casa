class HomeController < ApplicationController
  def index
    @cover_photo_url = ENV["COVER_PHOTO_URL"] || ""
    @is_user_subbed = Subscription.where(user: Current.user).exists?
  end
end
