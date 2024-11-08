require 'rails_helper'

describe "User sign out" do
  context "when user is establishment Owner" do
    it "establishment owner can sign out without registering an establishment" do
      owner = User.create!(
        role: 'owner',
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

      login_as(owner)
      visit root_path

      within('header') do
        click_on 'Sair'
      end

      expect(owner.owned_establishment.present?).to be false
      expect(page).to have_content 'Entrar'
      expect(current_path).to eq new_user_session_path
    end

    it "establishment owner can sign out without registering business hours" do
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

      within('header') do
        click_on 'Sair'
      end

      expect(owner.owned_establishment.present?).to be true
      expect(owner.owned_establishment.opened_for_business?).to be false
      expect(page).to have_content 'Entrar'
      expect(current_path).to eq new_user_session_path
    end

    it "establishment owner can sign out from the homepage after registering establishment and business hours" do
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

      owner.owned_establishment.business_hours.create!(
        day_of_week: 'sunday',
        status: 'opened',
        open_time: '10:00',
        close_time: '20:00')

      login_as(owner)
      visit root_path

      within('header') do
        click_on 'Sair'
      end

      expect(owner.owned_establishment.present?).to be true
      expect(owner.owned_establishment.opened_for_business?).to be true
      expect(page).to have_content 'Entrar'
      expect(current_path).to eq new_user_session_path
    end
  end

  context "when user is establishment Employee" do
    it "establishment employee can sign out from the homepage" do
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

      owner.owned_establishment.pending_employees.create!(
        email: 'billgates@outlook.com',
        personal_national_id: '556.452.500-01')

      employee = User.create!(
        role: 'employee',
        name: 'Bill',
        lastname: 'Gates',
        personal_national_id: '556.452.500-01',
        email: 'billgates@outlook.com',
        password: 'bill2*6gates')

      login_as(employee)
      visit root_path

      within('header') do
        click_on 'Sair'
      end

      expect(page).to have_content 'Entrar'
      expect(current_path).to eq new_user_session_path
    end
  end
end
