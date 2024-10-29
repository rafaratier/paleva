require 'rails_helper'

describe "Establishment registration" do
  let!(:user) { User.create!(
    name: 'Jeff',
    lastname: 'Bezos',
    personal_national_id: CPF.generate(true),
    email: 'jeffbezos@amazon.com',
    password: 'jeff2*6bezos')
  }

  context "with invalid data" do
    it "can not register without valid business national id" do
      login_as(user)
      visit root_path

      fill_in "Nome fantasia",	with: "Paleva"
      fill_in "Razão social",	with: "Pega e Leva ME"
      fill_in "CNPJ",	with: "00.000.000/0000-00"
      fill_in "E-mail",	with: "contato@paleva.com.br"
      fill_in "Telefone",	with: "0123456789"
      fill_in "Nome da rua", with: "AV Kennedy"
      fill_in "Número",	with: "123"
      fill_in "Bairro",	with: "Forte"
      fill_in "Cidade",	with: "Praia Grande"
      fill_in "Estado",	with: "São Paulo"
      fill_in "País",	with: "Brasil"

      click_on 'Criar Estabelecimento'

      expect(page).to have_content 'CNPJ inválido.'
      expect(current_path).to eq root_path
      expect(current_user.establishment.nil?).to be false
    end
  end
end
