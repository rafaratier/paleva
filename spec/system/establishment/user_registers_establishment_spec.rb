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
    it "can not register with invalid format business national id" do
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

      expect(page).to have_content 'CNPJ Inválido'
      expect(current_path).to eq establishments_path
      expect(user.establishment.nil?).to be true
    end

    it "can not register with business national id already taken " do
      same_business_national_id = CNPJ.generate(true)

      other_user = User.create!(
        name: 'Bill',
        lastname: 'Gates',
        personal_national_id: CPF.generate(true),
        email: 'billgates@outlook.com',
        password: 'bill2*6gates')

      Establishment.create!(
        trade_name: 'Papega',
        legal_name: 'Pede e Pega ME',
        business_national_id: same_business_national_id,
        phone: '0123456789',
        email: 'contato@papega.com.br',
        owner: other_user
      )

      login_as(user)
      visit root_path

      fill_in "Nome fantasia",	with: "Paleva"
      fill_in "Razão social",	with: "Pega e Leva ME"
      fill_in "CNPJ",	with: same_business_national_id
      fill_in "E-mail",	with: "contato@paleva.com.br"
      fill_in "Telefone",	with: "0123456789"
      fill_in "Nome da rua", with: "AV Kennedy"
      fill_in "Número",	with: "123"
      fill_in "Bairro",	with: "Forte"
      fill_in "Cidade",	with: "Praia Grande"
      fill_in "Estado",	with: "São Paulo"
      fill_in "País",	with: "Brasil"

      click_on 'Criar Estabelecimento'

      expect(page).to have_content 'CNPJ já está em uso'
      expect(current_path).to eq establishments_path
      expect(user.establishment.nil?).to be true
    end
  end
end
