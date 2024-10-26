require 'rails_helper'

describe 'User sign up' do
  context 'with invalid data' do
    it 'can not create account without lastname' do
      visit new_user_session_path
      click_on 'Criar conta'

      within('form') do
        fill_in 'Nome', with: 'Jeff'
        fill_in 'Sobrenome', with: ''
        fill_in 'CPF', with: '00000000000'
        fill_in 'E-mail', with: 'jeffbezos@gmail.com'
        fill_in 'Senha', with: '2*6JEFFbb001'
        fill_in 'Confirme sua senha', with: '2*6JEFFbb001'
        click_on 'Criar conta'
      end

      expect(page).to have_content 'Sobrenome não pode ficar em branco'
      expect(current_path).to eq new_user_session_path
    end
  end
end
