require 'rails_helper'

describe "User sign in" do
  let!(:user) { User.create!(
    name: 'Jeff',
    lastname: 'Bezos',
    personal_national_id: CPF.generate(true),
    email: 'jeffbezos@amazon.com',
    password: 'jeff2*6bezos')
  }

  context "with invalid data" do
    it "can not sign with wrong email" do
      visit new_user_session_path

      within('form') do
        fill_in 'E-mail', with: 'jeffbOzOs@amazon.com'
        fill_in 'Senha', with: 'jeff2*6bezos'
        click_on 'Entrar'
      end

      expect(page).to have_content 'E-mail ou senha inválidos.'
      expect(current_path).to eq new_user_session_path
    end

    it "can not sign with wrong password" do
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

      expect(page).to have_content 'E-mail ou senha inválidos.'
      expect(current_path).to eq new_user_session_path
    end
  end

  context "with valid data and without registered establishment" do
    it "can successfully sign in and see establishment registration page" do
      user = User.find_by!(email: 'jeffbezos@amazon.com')
      logout(user)
      visit new_user_session_path

      within('form') do
        fill_in 'E-mail', with: 'jeffbezos@amazon.com'
        fill_in 'Senha', with: 'jeff2*6bezos'
        click_on 'Entrar'
      end

      expect(page).to have_content 'Olá, Jeff Bezos'
      expect(user.establishment.nil?).to be true
      expect(current_path).to eq new_establishment_path
    end
  end

  context "with valid data and registered establishment" do
    it "can successfully sign in and see homepage" do
      user = User.find_by!(email: 'jeffbezos@amazon.com')

      Establishment.create!(
        trade_name: 'Amazon',
        legal_name: 'Amazon.com',
        business_national_id: CNPJ.generate(true),
        phone: '0123456789',
        email: 'contact@amazon.com',
        owner: user,
        business_hours: {
          sunday: [],
          monday: [ '12:00', '20:00' ],
          tuesday: [ '12:00', '20:00' ],
          wednesday: [ '12:00', '20:00' ],
          thursday: [ '12:00', '20:00' ],
          friday: [ '12:00', '22:00' ],
          saturday: [ '12:00', '22:00' ] },
      )

      visit new_user_session_path

      within('form') do
        fill_in 'E-mail', with: 'jeffbezos@amazon.com'
        fill_in 'Senha', with: 'jeff2*6bezos'
        click_on 'Entrar'
      end

      expect(page).to have_content 'Olá, Jeff Bezos'
      expect(user.establishment.nil?).to be false
      expect(current_path).to eq root_path
    end
  end
end
