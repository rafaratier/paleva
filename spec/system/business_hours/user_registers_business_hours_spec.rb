require 'rails_helper'

describe "Business Hours registration" do
  context "when user has establishment without business hours defined" do
    it "after login gets redirected to define business hours" do
      user = User.create!(
      name: 'Jeff',
      lastname: 'Bezos',
      personal_national_id: CPF.generate(true),
      email: 'jeffbezos@amazon.com',
      password: 'jeff2*6bezos')

      establishment = Establishment.create!(
      trade_name: 'Papega',
      legal_name: 'Pede e Pega ME',
      business_national_id: CNPJ.generate(true),
      phone: '0123456789',
      email: 'contato@papega.com.br',
      owner: user)

      login_as(user)
      visit root_path

      expect(user.establishment.present?).to be true
      expect(establishment.business_hours.present?).to be false
      expect(current_path).to eq new_establishment_business_hour_path(establishment.id)
    end
  end
end
