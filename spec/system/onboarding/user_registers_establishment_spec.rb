require 'rails_helper'

describe "Establishment registration step" do
  context "with valid data" do
    it "can successfully register the establishment" do
      user = User.create!(
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

      login_as(user)
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

      establishment = user.reload_establishment

      expect(page).to have_content 'Estabelecimento cadastrado com sucesso'
      expect(establishment.nil?).to be false
      expect(establishment.trade_name).to eq 'Papega'
      expect(establishment.address.street_name).to eq 'Av Pres. Kennedy'
    end

    it "with successful establishment registration, user gets redirected to register the business hours" do
      user = User.create!(
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

      login_as(user)
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

      establishment = user.reload_establishment

      expect(page).to have_content 'Estabelecimento cadastrado com sucesso'
      expect(establishment.nil?).to be false
      expect(current_path).to eq establishment_business_hours_path(establishment.id)
    end
  end

  context "with invalid data" do
    it "can not register with invalid formatted business national id" do
      user = User.create!(
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

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
      expect(current_path).to eq establishment_path
      expect(user.establishment.nil?).to be true
    end

    it "can not register when business national id already taken" do
      user = User.create!(
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

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
      expect(current_path).to eq establishment_path
      expect(user.establishment.nil?).to be true
    end

    it "can not register with invalid formatted email" do
      user = User.create!(
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

      login_as(user)
      visit root_path

      fill_in "Nome fantasia",	with: "Paleva"
      fill_in "Razão social",	with: "Pega e Leva ME"
      fill_in "CNPJ",	with: CNPJ.generate(true)
      fill_in "E-mail",	with: "contatopaleva.com.br"
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
      expect(user.establishment.nil?).to be true
    end

    it "can not register when email is already taken" do
      user = User.create!(
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

      same_email_address = "contato@papega.com.br"

      other_user = User.create!(
        name: 'Bill',
        lastname: 'Gates',
        personal_national_id: CPF.generate(true),
        email: 'billgates@outlook.com',
        password: 'bill2*6gates')

      Establishment.create!(
        trade_name: 'Papega',
        legal_name: 'Pede e Pega ME',
        business_national_id: CNPJ.generate(true),
        phone: '0123456789',
        email: same_email_address,
        owner: other_user
      )

      login_as(user)
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
      expect(user.establishment.nil?).to be true
    end

    it "can not register when trade name is already taken within state" do
      user = User.create!(
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

      same_trade_name = 'Papega'
      same_state = 'São Paulo'

      other_user = User.create!(
        name: 'Bill',
        lastname: 'Gates',
        personal_national_id: CPF.generate(true),
        email: 'billgates@outlook.com',
        password: 'bill2*6gates')

      other_establishment = Establishment.create!(
        trade_name: same_trade_name,
        legal_name: 'Pede e Pega ME',
        business_national_id: CNPJ.generate(true),
        phone: '9876543210',
        email: 'contato@papega.com.br',
        owner: other_user
      )

      Address.create!(
        street_name: 'Av: Pres. Wilson',
        street_number: 10,
        neighborhood: 'Boa Vista',
        city: 'São Vicente',
        state: same_state,
        country: 'Brasil',
        establishment: other_establishment
      )

      login_as(user)
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
      expect(user.establishment.nil?).to be true
    end
  end
end
