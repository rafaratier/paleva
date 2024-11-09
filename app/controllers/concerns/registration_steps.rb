module RegistrationSteps
  extend ActiveSupport::Concern

  included do
    before_action :require_registration_steps
  end

  private

  def require_registration_steps
    return unless user_signed_in? && !is_request_to_logout?
    return unless user_signed_in? && current_user.owner?

    if current_user.owned_establishment.nil?
      redirect_to new_establishment_path
    end

    if current_user.owned_establishment.present? && !current_user.owned_establishment.open_for_business?
      redirect_to establishment_business_hours_path(current_user.owned_establishment.id)
    end
  end

  def is_request_to_logout?
    request.path == destroy_user_session_path
  end
end
