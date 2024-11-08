require 'rails_helper'

describe "User sign in" do
  context "when user is establishment Owner with invalid data" do
    it "can not sign with wrong email" do
      User.create!(
        role: 'owner',
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

      visit new_user_session_path

      within('form') do
        fill_in 'E-mail', with: 'jeffbOzOs@amazon.com'
        fill_in 'Senha', with: 'jeff2*6bezos'
        click_on 'Entrar'
      end

      expect(User.find_by(email: 'jeffbOzOs@amazon.com')).to be nil
      expect(page).to have_content 'E-mail ou senha inválidos.'
      expect(current_path).to eq new_user_session_path
    end

    it "can not sign with wrong password" do
      User.create!(
        role: 'owner',
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

      visit new_user_session_path

      within('form') do
        fill_in 'E-mail', with: 'jeffbezos@amazon.com'
        fill_in 'Senha', with: 'jeff2*6bOzOs'
        click_on 'Entrar'
      end

      expect(page).to have_content 'E-mail ou senha inválidos.'
      expect(current_path).to eq new_user_session_path
    end

    it "can not sign when not registered" do
      visit new_user_session_path

      within('form') do
        fill_in 'E-mail', with: 'billgates@outlook.com'
        fill_in 'Senha', with: 'bill2*6gates'
        click_on 'Entrar'
      end

      expect(User.find_by(email: 'billgatesoutlook.com')).to be nil
      expect(page).to have_content 'E-mail ou senha inválidos.'
      expect(current_path).to eq new_user_session_path
    end
  end

  context "when user is establishment Owner with valid data and without registered establishment" do
    it "can successfully sign in and see establishment registration page" do
      owner = User.create!(
        role: 'owner',
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

      visit root_path

      within('form') do
        fill_in 'E-mail', with: 'jeffbezos@amazon.com'
        fill_in 'Senha', with: 'jeff2*6bezos'
        click_on 'Entrar'
      end

      expect(page).to have_content 'Olá, Jeff Bezos'
      expect(owner.establishment.nil?).to be true
      expect(current_path).to eq new_establishment_path
    end
  end

  context "when user is Owner with registered establishment but with no business hours registered" do
    it "can successfully sign in and see business hours page" do
      owner = User.create!(
        role: 'owner',
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

      establishment = Establishment.create!(
        trade_name: 'Amazon',
        legal_name: 'Amazon.com',
        business_national_id: CNPJ.generate(true),
        phone: '0123456789',
        email: 'contact@amazon.com',
        owner: owner)

      visit root_path

      within('form') do
        fill_in 'E-mail', with: 'jeffbezos@amazon.com'
        fill_in 'Senha', with: 'jeff2*6bezos'
        click_on 'Entrar'
      end

      expect(page).to have_content 'Olá, Jeff Bezos'
      expect(owner.owned_establishment.nil?).to be false
      expect(current_path).to eq establishment_business_hours_path(establishment.id)
    end
  end

  context "when user is Employee with invalid data" do
    it "can not sign with wrong email" do
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

      User.create!(
        role: 'employee',
        name: 'Bill',
        lastname: 'Gates',
        personal_national_id: '556.452.500-01',
        email: 'billgates@outlook.com',
        password: 'bill2*6gates')

      visit new_user_session_path

      within('form') do
        fill_in 'E-mail', with: 'william_h_gates@outlook.com'
        fill_in 'Senha', with: 'bill2*6gates'
        click_on 'Entrar'
      end

      expect(User.find_by(email: 'william_h_gates@outlook.com')).to be nil
      expect(page).to have_content 'E-mail ou senha inválidos.'
      expect(current_path).to eq new_user_session_path
    end

    it "can not sign with wrong password" do
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

      User.create!(
        role: 'employee',
        name: 'Bill',
        lastname: 'Gates',
        personal_national_id: '556.452.500-01',
        email: 'billgates@outlook.com',
        password: 'bill2*6gates')

      visit new_user_session_path

      within('form') do
        fill_in 'E-mail', with: 'billgates@outlook.com'
        fill_in 'Senha', with: 'senha errada'
        click_on 'Entrar'
      end

      expect(page).to have_content 'E-mail ou senha inválidos.'
      expect(current_path).to eq new_user_session_path
    end
  end

  context "when user is Employee with valid data" do
    it "can successfully sign in and see homepage" do
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

      owner.owned_establishment
        .pending_employees.create!(
        email: 'billgates@outlook.com',
        personal_national_id: '556.452.500-01')

      User.create!(
        role: 'employee',
        name: 'Bill',
        lastname: 'Gates',
        personal_national_id: '556.452.500-01',
        email: 'billgates@outlook.com',
        password: 'bill2*6gates')

      visit new_user_session_path

      within('form') do
        fill_in 'E-mail', with: 'billgates@outlook.com'
        fill_in 'Senha', with: 'bill2*6gates'
        click_on 'Entrar'
      end

      expect(page).to have_content 'Olá, Bill Gates'
      expect(page).to have_button 'Sair'
      expect(current_path).to eq root_path
    end
  end
end
