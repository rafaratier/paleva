class HomeController < ApplicationController
  def index
    @user_full_name = "#{current_user.name} #{current_user.lastname}"
  end
end
