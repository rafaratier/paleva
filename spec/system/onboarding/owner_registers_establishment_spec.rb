require 'rails_helper'

describe "Owner's establishment registration step" do
  context "when owner tries to access other page without registering an establishment" do
    it "owner should get redirected to the establishment registration page" do
      owner = User.create!(
        role: 'owner',
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

      login_as(owner)

      visit root_path

      expect(current_path).to eq new_establishment_path
    end
  end

  context "with valid data" do
    it "after successful establishment registration, owner gets redirected to register business hours" do
      owner = User.create!(
        role: 'owner',
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

      login_as(owner)
      visit root_path

      fill_in 'Nome fantasia',	with: 'Papega'
      fill_in 'Razão social',	with: 'Pega e Leva ME'
      fill_in 'CNPJ',	with: CNPJ.generate(true)
      fill_in 'E-mail',	with: 'contato@paleva.com.br'
      fill_in 'Telefone',	with: '0123456789'
      fill_in 'Nome da rua', with: 'Av Pres. Kennedy'
      fill_in 'Número',	with: '123'
      fill_in 'Bairro',	with: 'Forte'
      fill_in 'Cidade',	with: 'Praia Grande'
      fill_in 'Estado',	with: 'São Paulo'
      fill_in 'País',	with: 'Brasil'

      click_on 'Criar Estabelecimento'

      owner.reload

      expect(page).to have_content 'Estabelecimento cadastrado com sucesso'
      expect(owner.owned_establishment.present?).to be true
      expect(owner.owned_establishment.trade_name).to eq 'Papega'
      expect(current_path).to eq establishment_business_hours_path(owner.owned_establishment.id)
    end
  end

  context "with invalid data" do
    it "can not register establishment with invalid business national id" do
      owner = User.create!(
        role: 'owner',
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

      login_as(owner)
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
      expect(current_path).to eq establishment_path
      expect(owner.owned_establishment.nil?).to be true
    end

    it "can not register establishment when business national id already taken" do
      owner = User.create!(
        role: 'owner',
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

      same_business_national_id = CNPJ.generate(true)

      other_owner = User.create!(
        role: 'owner',
        name: 'Bill',
        lastname: 'Gates',
        personal_national_id: CPF.generate(true),
        email: 'billgates@outlook.com',
        password: 'bill2*6gates')

      other_owner.create_owned_establishment!(
        trade_name: 'Papega',
        legal_name: 'Pede e Pega ME',
        business_national_id: same_business_national_id,
        phone: '0123456789',
        email: 'contato@papega.com.br')

      login_as(owner)
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
      expect(current_path).to eq establishment_path
      expect(owner.owned_establishment.nil?).to be true
    end

    it "can not register establishment with invalid email" do
      owner = User.create!(
        role: 'owner',
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

      login_as(owner)
      visit root_path

      fill_in "Nome fantasia",	with: "Paleva"
      fill_in "Razão social",	with: "Pega e Leva ME"
      fill_in "CNPJ",	with: CNPJ.generate(true)
      fill_in "E-mail",	with: "@paleva.com.br"
      fill_in "Telefone",	with: "0123456789"
      fill_in "Nome da rua", with: "AV Kennedy"
      fill_in "Número",	with: "123"
      fill_in "Bairro",	with: "Forte"
      fill_in "Cidade",	with: "Praia Grande"
      fill_in "Estado",	with: "São Paulo"
      fill_in "País",	with: "Brasil"

      click_on 'Criar Estabelecimento'

      expect(page).to have_content 'E-mail Inválido'
      expect(current_path).to eq establishment_path
      expect(owner.owned_establishment.nil?).to be true
    end

    it "can not register establishment when email is already taken" do
      owner = User.create!(
        role: 'owner',
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

      same_email_address = "contato@papega.com.br"

      other_owner = User.create!(
        role: 'owner',
        name: 'Bill',
        lastname: 'Gates',
        personal_national_id: CPF.generate(true),
        email: 'billgates@outlook.com',
        password: 'bill2*6gates')

      other_owner.create_owned_establishment!(
        trade_name: 'Papega',
        legal_name: 'Pede e Pega ME',
        business_national_id: CNPJ.generate(true),
        phone: '0123456789',
        email: same_email_address)

      login_as(owner)
      visit root_path

      fill_in "Nome fantasia",	with: "Paleva"
      fill_in "Razão social",	with: "Pega e Leva ME"
      fill_in "CNPJ",	with: CNPJ.generate(true)
      fill_in "E-mail",	with: same_email_address
      fill_in "Telefone",	with: "0123456789"
      fill_in "Nome da rua", with: "AV Kennedy"
      fill_in "Número",	with: "123"
      fill_in "Bairro",	with: "Forte"
      fill_in "Cidade",	with: "Praia Grande"
      fill_in "Estado",	with: "São Paulo"
      fill_in "País",	with: "Brasil"

      click_on 'Criar Estabelecimento'

      expect(page).to have_content 'E-mail já está em uso'
      expect(current_path).to eq establishment_path
      expect(owner.owned_establishment.nil?).to be true
    end

    it "can not register establishment when trade name is already taken within state" do
      owner = User.create!(
        role: 'owner',
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

      same_trade_name = 'Papega'
      same_state = 'São Paulo'

      other_owner = User.create!(
        role: 'owner',
        name: 'Bill',
        lastname: 'Gates',
        personal_national_id: CPF.generate(true),
        email: 'billgates@outlook.com',
        password: 'bill2*6gates')

      other_owner.create_owned_establishment!(
        trade_name: same_trade_name,
        legal_name: 'Pede e Pega ME',
        business_national_id: CNPJ.generate(true),
        phone: '9876543210',
        email: 'contato@papega.com.br')

      other_owner.owned_establishment.create_address!(
        street_name: 'Av: Pres. Wilson',
        street_number: 10,
        neighborhood: 'Boa Vista',
        city: 'São Vicente',
        state: same_state,
        country: 'Brasil')

      login_as(owner)
      visit root_path

      fill_in 'Nome fantasia',	with: same_trade_name
      fill_in 'Razão social',	with: 'Pega e Leva ME'
      fill_in 'CNPJ',	with: CNPJ.generate(true)
      fill_in 'E-mail',	with: 'contato@paleva.com.br'
      fill_in 'Telefone',	with: '0123456789'
      fill_in 'Nome da rua', with: 'AV Kennedy'
      fill_in 'Número',	with: '123'
      fill_in 'Bairro',	with: 'Forte'
      fill_in 'Cidade',	with: 'Praia Grande'
      fill_in 'Estado',	with: same_state
      fill_in 'País',	with: 'Brasil'

      click_on 'Criar Estabelecimento'

      expect(page).to have_content 'Nome fantasia já está em uso'
      expect(current_path).to eq establishment_path
      expect(owner.owned_establishment.nil?).to be true
    end
  end
end
