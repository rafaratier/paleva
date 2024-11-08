require 'rails_helper'

describe "Business Hours registration step" do
  context "when establishment has no 'opened' days set" do
    it "newly registered establishment should start 'closed' for business and redirect owner to business hours page" do
      owner = User.create!(
        role: 'owner',
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

      owner.create_owned_establishment!(
        trade_name: 'Papega',
        legal_name: 'Pede e Pega ME',
        business_national_id: CNPJ.generate(true),
        phone: '0123456789',
        email: 'contato@papega.com.br')

      login_as(owner)

      visit root_path

      expect(page).not_to have_content 'Aberto'
      expect(page).to have_content 'Fechado'
      expect(owner.owned_establishment.open_for_business?).to be false
      expect(current_path).to eq establishment_business_hours_path(owner.owned_establishment.id)
    end

    it "owner should get redirected to the business hours page when he tries to access other pages" do
      owner = User.create!(
        role: 'owner',
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

      owner.create_owned_establishment!(
        trade_name: 'Papega',
        legal_name: 'Pede e Pega ME',
        business_national_id: CNPJ.generate(true),
        phone: '0123456789',
        email: 'contato@papega.com.br')

      login_as(owner)

      visit root_path

      click_on 'Menu'

      expect(owner.owned_establishment.open_for_business?).to be false
      expect(current_path).to eq establishment_business_hours_path(owner.owned_establishment.id)
    end

    it "owner should set at least one day as 'opened' to finish onboarding and see homepage" do
      owner = User.create!(
        role: 'owner',
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

      owner.create_owned_establishment!(
        trade_name: 'Papega',
        legal_name: 'Pede e Pega ME',
        business_national_id: CNPJ.generate(true),
        phone: '0123456789',
        email: 'contato@papega.com.br')

      login_as(owner)
      visit root_path

      click_on 'Domingo'

      fill_in 'Abre às',	with: '12:00'
      fill_in 'Fecha às',	with: '20:00'

      click_on 'Atualizar Horário de funcionamento'

      click_on 'Menu'

      expect(owner.owned_establishment.open_for_business?).to be true
      expect(current_path).to eq root_path
    end
  end
end
