module RegistrationSteps
  extend ActiveSupport::Concern

  included do
    before_action :require_registration_steps
  end

  private

  def require_registration_steps
    return unless user_signed_in?

    if current_user.establishment.nil?
      redirect_to new_establishment_path unless on_establishment_or_logout_path?
      return
    end

    if current_user.establishment.business_hours.empty?
      redirect_to new_establishment_business_hour_path(current_user.establishment.id) unless on_business_hour_or_logout_path?
    end
  end

  def on_establishment_or_logout_path?
    [ new_establishment_path, destroy_user_session_path, establishment_path ].include?(request.path)
  end

  def on_business_hour_or_logout_path?
    [ new_establishment_business_hour_path(current_user.establishment.id), destroy_user_session_path ].include?(request.path)
  end
end
