require 'rails_helper'

describe 'User sign up' do
  let(:valid_cpf) { CPF.generate(true) }

  context 'with invalid data' do
    it 'can not create account without lastname' do
      visit new_user_session_path
      click_on 'Criar conta'

      within('form') do
        fill_in 'Nome', with: 'Jeff'
        fill_in 'Sobrenome', with: ''
        fill_in 'CPF', with: valid_cpf
        fill_in 'E-mail', with: 'jeffbezos@gmail.com'
        fill_in 'Senha', with: 'jeff2*6bezos'
        fill_in 'Confirme sua senha', with: 'jeff2*6bezos'
        click_on 'Criar conta'
      end

      expect(page).to have_content 'Não foi possível salvar usuário: 2 erro'
      expect(page).to have_content 'Sobrenome não pode ficar em branco'
      expect(page).to have_content 'Sobrenome é muito curto'
      expect(User.count).to eq 0
    end

    it 'can not create account without email' do
      visit new_user_session_path
      click_on 'Criar conta'

      within('form') do
        fill_in 'Nome', with: 'Jeff'
        fill_in 'Sobrenome', with: 'Bezos'
        fill_in 'CPF', with: valid_cpf
        fill_in 'E-mail', with: ''
        fill_in 'Senha', with: 'jeff2*6bezos'
        fill_in 'Confirme sua senha', with: 'jeff2*6bezos'
        click_on 'Criar conta'
      end

      expect(page).to have_content 'Não foi possível salvar usuário: 1 erro'
      expect(page).to have_content 'E-mail não pode ficar em branco'
      expect(User.count).to eq 0
    end

    it 'can not create account when email is already in use' do
      same_email = 'jeffbezos@amazon.com'

      User.create!(
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: valid_cpf,
        email: same_email,
        password: 'jeff2*6bezos'
      )

      visit new_user_session_path
      click_on 'Criar conta'

      within('form') do
        fill_in 'Nome', with: 'Bill'
        fill_in 'Sobrenome', with: 'Gates'
        fill_in 'CPF', with: CPF.generate(true)
        fill_in 'E-mail', with: same_email
        fill_in 'Senha', with: 'bill2*6gates'
        fill_in 'Confirme sua senha', with: 'bill2*6gates'
        click_on 'Criar conta'
      end

      expect(page).to have_content 'Não foi possível salvar usuário'
      expect(page).to have_content 'E-mail já está em uso'
    end

    it 'can not create account when personal national ID is already in use' do
      User.create!(
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: valid_cpf,
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos'
      )

      visit new_user_session_path
      click_on 'Criar conta'

      within('form') do
        fill_in 'Nome', with: 'Bill'
        fill_in 'Sobrenome', with: 'Gates'
        fill_in 'CPF', with: valid_cpf
        fill_in 'E-mail', with: 'billgates@outlook.com'
        fill_in 'Senha', with: 'bill2*6gates'
        fill_in 'Confirme sua senha', with: 'bill2*6gates'
        click_on 'Criar conta'
      end

      expect(page).to have_content 'Não foi possível salvar usuário'
      expect(page).to have_content 'CPF já está em uso'
    end
  end

  context 'with valid data' do
    it 'can successfully create account' do
      visit new_user_session_path
      click_on 'Criar conta'

      within('form') do
        fill_in 'Nome', with: 'Jeff'
        fill_in 'Sobrenome', with: 'Bezos'
        fill_in 'CPF', with: valid_cpf
        fill_in 'E-mail', with: 'jeffbezos@gmail.com'
        fill_in 'Senha', with: 'jeff2*6bezos'
        fill_in 'Confirme sua senha', with: 'jeff2*6bezos'
        click_on 'Criar conta'
      end

      expect(page).to have_content 'Cadastro realizado com sucesso.'
      expect(User.last.personal_national_id).to eq valid_cpf
      expect(current_path).to eq new_establishment_path
    end
  end
end
