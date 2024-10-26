require 'rails_helper'

describe 'User sign up' do
  context 'with invalid data' do
    it 'can not create account without lastname' do
      visit new_user_session_path
      click_on 'Criar conta'

      within('form') do
        fill_in 'Nome', with: 'Jeff'
        fill_in 'Sobrenome', with: ''
        fill_in 'CPF', with: CPF.generate(true)
        fill_in 'E-mail', with: 'jeffbezos@gmail.com'
        fill_in 'Senha', with: '2*6JEFFbb001'
        fill_in 'Confirme sua senha', with: '2*6JEFFbb001'
        click_on 'Criar conta'
      end

      expect(page).to have_content 'Não foi possível salvar usuário: 2 erro'
      expect(page).to have_content 'Sobrenome não pode ficar em branco'
      expect(page).to have_content 'Sobrenome é muito curto'
      expect(User.count).to eq 0
    end
  end
end
