class HomeController < ApplicationController
  def index
    @cover_photo_url = ENV["COVER_PHOTO_URL"] || ""
  end
end
