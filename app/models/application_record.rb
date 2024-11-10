class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.human_enum_name(enum_name, enum_value)
    I18n.t("activerecord.attributes.#{model_name.
           i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}")
  end

  def email_must_be_uniq
    if User.exists?(email: email) ||
      Establishment.exists?(email: email) ||
      PendingEmployee.exists?(email: email)
      errors.add(:email, :taken)
    end
  end

  def personal_national_id_must_be_uniq
    if User.exists?(personal_national_id: personal_national_id) ||
      PendingEmployee.exists?(personal_national_id: personal_national_id)
      errors.add(:personal_national_id, :taken)
    end
  end
end
