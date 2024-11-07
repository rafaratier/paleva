require 'rails_helper'

describe 'Establishment employee sign up' do
  context 'with invalid data' do
    it 'can not create account without lastname' do
      visit new_user_registration_path

      within('form') do
        choose 'Funcionário'
        fill_in 'Nome', with: 'Jeff'
        fill_in 'Sobrenome', with: ''
        fill_in 'CPF', with: CPF.generate(true)
        fill_in 'E-mail', with: 'jeffbezos@gmail.com'
        fill_in 'Senha', with: 'jeff2*6bezos'
        fill_in 'Confirme sua senha', with: 'jeff2*6bezos'
        click_on 'Criar conta'
      end

      expect(page).to have_content 'Não foi possível salvar usuário: 2 erros'
      expect(page).to have_content 'Sobrenome é muito curto'
      expect(User.count).to eq 0
      expect(current_path).to eq user_registration_path
    end

    it 'can not create account without email' do
      visit new_user_registration_path

      within('form') do
        choose 'Funcionário'
        fill_in 'Nome', with: 'Jeff'
        fill_in 'Sobrenome', with: 'Bezos'
        fill_in 'CPF', with: CPF.generate(true)
        fill_in 'E-mail', with: ''
        fill_in 'Senha', with: 'jeff2*6bezos'
        fill_in 'Confirme sua senha', with: 'jeff2*6bezos'
        click_on 'Criar conta'
      end

      expect(page).to have_content 'Não foi possível salvar usuário'
      expect(page).to have_content 'E-mail não pode ficar em branco'
      expect(User.count).to eq 0
      expect(current_path).to eq user_registration_path
    end

    it 'can not create account when email is already in use by an establishment owner' do
      same_email = 'jeffbezos@amazon.com'

      User.create!(
        role: 'owner',
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: same_email,
        password: 'jeff2*6bezos'
      )

      visit new_user_registration_path

      within('form') do
        choose 'Funcionário'
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
      expect(current_path).to eq user_registration_path
    end

    it 'can not create account when personal national ID is already in use by an establishment owner' do
      same_personal_national_id = '163.925.890-66'
      User.create!(
        role: 'owner',
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: same_personal_national_id,
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

      visit new_user_registration_path

      within('form') do
        choose 'Funcionário'
        fill_in 'Nome', with: 'Bill'
        fill_in 'Sobrenome', with: 'Gates'
        fill_in 'CPF', with: same_personal_national_id
        fill_in 'E-mail', with: 'billgates@outlook.com'
        fill_in 'Senha', with: 'bill2*6gates'
        fill_in 'Confirme sua senha', with: 'bill2*6gates'
        click_on 'Criar conta'
      end

      expect(page).to have_content 'Não foi possível salvar usuário'
      expect(page).to have_content 'CPF já está em uso'
      expect(current_path).to eq user_registration_path
    end

    it 'can not create account when email is already in use by other employee' do
      owner = User.create!(
        role: 'owner',
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
        owner: owner)

      PendingEmployee.create!(
        personal_national_id: '163.925.890-66',
        email: 'billgates@outlook.com',
        establishment: establishment)

      same_email_address = 'billgates@outlook.com'

      User.create!(
        role: 'employee',
        name: 'Bill',
        lastname: 'Gates',
        personal_national_id: '163.925.890-66',
        email: same_email_address,
        password: 'bill2*6gates',
        establishment: establishment)

      visit new_user_registration_path

      within('form') do
        choose 'Funcionário'
        fill_in 'Nome', with: 'Bill'
        fill_in 'Sobrenome', with: 'Gates'
        fill_in 'CPF', with: '163.925.890-66'
        fill_in 'E-mail', with: same_email_address
        fill_in 'Senha', with: 'bill2*6gates'
        fill_in 'Confirme sua senha', with: 'bill2*6gates'
        click_on 'Criar conta'
      end

      expect(page).to have_content 'Não foi possível salvar usuário'
      expect(page).to have_content 'E-mail já está em uso'
      expect(current_path).to eq user_registration_path
    end

    it 'can not create account when email is already in use by other employee' do
      owner = User.create!(
        role: 'owner',
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
        owner: owner)

      PendingEmployee.create!(
        personal_national_id: '163.925.890-66',
        email: 'billgates@outlook.com',
        establishment: establishment)

      same_personal_national_id = '163.925.890-66'

      User.create!(
        role: 'employee',
        name: 'Bill',
        lastname: 'Gates',
        personal_national_id: same_personal_national_id,
        email: 'billgates@outlook.com',
        password: 'bill2*6gates',
        establishment: establishment)

      visit new_user_registration_path

      within('form') do
        choose 'Funcionário'
        fill_in 'Nome', with: 'Bill'
        fill_in 'Sobrenome', with: 'Gates'
        fill_in 'CPF', with: same_personal_national_id
        fill_in 'E-mail', with: 'billgates@outlook.com'
        fill_in 'Senha', with: 'bill2*6gates'
        fill_in 'Confirme sua senha', with: 'bill2*6gates'
        click_on 'Criar conta'
      end

      expect(page).to have_content 'Não foi possível salvar usuário'
      expect(page).to have_content 'CPF já está em uso'
      expect(current_path).to eq user_registration_path
    end
  end

  context 'with valid data' do
    it 'can not create account if not allowed by establishment owner' do
      owner = User.create!(
        role: 'owner',
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

      Establishment.create!(
        trade_name: 'Papega',
        legal_name: 'Pede e Pega ME',
        business_national_id: CNPJ.generate(true),
        phone: '0123456789',
        email: 'contato@papega.com.br',
        owner: owner)

      visit new_user_registration_path

      within('form') do
        choose 'Funcionário'
        fill_in 'Nome', with: 'Bill'
        fill_in 'Sobrenome', with: 'Gates'
        fill_in 'CPF', with: '163.925.890-66'
        fill_in 'E-mail', with: 'billgates@outlook.com'
        fill_in 'Senha', with: 'bill2*6gates'
        fill_in 'Confirme sua senha', with: 'bill2*6gates'
        click_on 'Criar conta'
      end

      expect(page).to have_content 'Você não possui permissão para cadastro como funcionário. Contate o estabelecimento responsável.'
      expect(PendingEmployee.find_by(personal_national_id: '163.925.890-66')).to be nil
      expect(User.find_by(personal_national_id: '163.925.890-66')).to be nil
      expect(current_path).to eq user_registration_path
    end

    it 'can successfully create account if previously allowed by establishment owner' do
      owner = User.create!(
        role: 'owner',
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
        owner: owner)

      PendingEmployee.create!(
        email: 'billgates@outlook.com',
        personal_national_id: '163.925.890-66',
        establishment: establishment)

      visit new_user_registration_path

      within('form') do
        choose 'Funcionário'
        fill_in 'Nome', with: 'Bill'
        fill_in 'Sobrenome', with: 'Gates'
        fill_in 'CPF', with: '163.925.890-66'
        fill_in 'E-mail', with: 'billgates@outlook.com'
        fill_in 'Senha', with: 'bill2*6gates'
        fill_in 'Confirme sua senha', with: 'bill2*6gates'
        click_on 'Criar conta'
      end

      expect(page).to have_content 'Cadastro realizado com sucesso.'
      expect(PendingEmployee.last.personal_national_id).to eq User.last.personal_national_id
      expect(PendingEmployee.last.email).to eq User.last.email
      expect(User.last.role).to eq 'employee'
      expect(current_path).to eq root_path
    end
  end
end
