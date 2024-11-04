require 'rails_helper'

describe "Business Hours registration step" do
  context "with establishment already registered" do
    it "can successfully register business hours" do
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

      within '#edit-sunday' do
        click_on 'Editar horário'
      end

      expect(current_path).to eq edit_establishment_business_hour_path(establishment.id)
    end
  end
end
