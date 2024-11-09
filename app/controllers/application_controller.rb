class ApplicationController < ActionController::Base
  include RegistrationSteps

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :set_user_full_name

  before_action :set_establishment

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :role, :name, :lastname, :personal_national_id ])
  end

  def set_user_full_name
    @user_full_name = "#{current_user.name} #{current_user.lastname}" if current_user
  end

  def set_establishment
    @establishment = Establishment.find_by!(owner_id: current_user.id)
  end
end
