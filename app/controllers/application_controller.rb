class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :require_registration

  before_action :set_user_full_name

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :lastname, :personal_national_id ])
  end

  def require_registration
    if user_signed_in? && current_user.establishment.nil? && request.path != new_establishment_path && request.path != destroy_user_session_path
      redirect_to new_establishment_path
    end
  end

  def set_user_full_name
    @user_full_name = "#{current_user.name} #{current_user.lastname}" if current_user
  end
end
