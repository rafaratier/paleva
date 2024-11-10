require 'rails_helper'

describe "Owner registers a new employee" do
  context "with valid data" do
    it "owner can register employee with valid data" do
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

      sunday_business_hour = owner.owned_establishment.business_hours.sunday

      sunday_business_hour.update!(
        day_of_week: 'sunday',
        status: 'opened',
        open_time: '12:00',
        close_time: '20:00')

      login_as(owner)
      visit new_establishment_employee_path(owner.owned_establishment)

      fill_in "E-mail",	with: "billgates@outlook.com"
      fill_in "CPF",	with: "984.823.790-97"

      click_on 'Permitir cadastro'

      pending_employee = PendingEmployee.find_by(email: 'billgates@outlook.com')

      expect(pending_employee.establishment_id).to eq owner.owned_establishment.id
      expect(page).to have_content 'E-mail billgates@outlook.com'
      expect(page).to have_content 'CPF 984.823.790-97'
      expect(current_path).to eq establishment_employees_path(owner.owned_establishment)
    end

    it 'pending employee initial status must be "pending"' do
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

      sunday_business_hour = owner.owned_establishment.business_hours.sunday

      sunday_business_hour.update!(
        day_of_week: 'sunday',
        status: 'opened',
        open_time: '12:00',
        close_time: '20:00')

      login_as(owner)
      visit new_establishment_employee_path(owner.owned_establishment)

      fill_in "E-mail",	with: "billgates@outlook.com"
      fill_in "CPF",	with: "984.823.790-97"

      click_on 'Permitir cadastro'


      expect(page).to have_content 'Estado: Pendente'
      expect(current_path).to eq establishment_employees_path(owner.owned_establishment)
    end
  end

  context "with invalid data" do
    it "owner can not register employee when personal national id is taken" do
      same_personal_national_id = '055.969.050-97'

      owner = User.create!(
        role: 'owner',
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: same_personal_national_id,
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

      owner.create_owned_establishment!(
        trade_name: 'Papega',
        legal_name: 'Pede e Pega ME',
        business_national_id: CNPJ.generate(true),
        phone: '0123456789',
        email: 'contato@papega.com.br')

      sunday_business_hour = owner.owned_establishment.business_hours.sunday

      sunday_business_hour.update!(
        day_of_week: 'sunday',
        status: 'opened',
        open_time: '12:00',
        close_time: '20:00')

      login_as(owner)
      visit new_establishment_employee_path(owner.owned_establishment)

      fill_in "E-mail",	with: "billgates@outlook.com"
      fill_in "CPF",	with: same_personal_national_id

      click_on 'Permitir cadastro'

      expect(PendingEmployee.last).to be nil
      expect(page).to have_content 'CPF já está em uso'
      expect(current_path).to eq establishment_employees_path(owner.owned_establishment)
    end

    it 'owner can not register employee when email is taken' do
      same_email = 'jeffbezos@amazon.com'

      owner = User.create!(
        role: 'owner',
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: same_email,
        password: 'jeff2*6bezos')

      owner.create_owned_establishment!(
        trade_name: 'Papega',
        legal_name: 'Pede e Pega ME',
        business_national_id: CNPJ.generate(true),
        phone: '0123456789',
        email: 'contato@papega.com.br')

      sunday_business_hour = owner.owned_establishment.business_hours.sunday

      sunday_business_hour.update!(
        day_of_week: 'sunday',
        status: 'opened',
        open_time: '12:00',
        close_time: '20:00')

      login_as(owner)
      visit new_establishment_employee_path(owner.owned_establishment)

      fill_in "E-mail",	with: same_email
      fill_in "CPF",	with: "984.823.790-97"

      click_on 'Permitir cadastro'

      p PendingEmployee.exists?(email: same_email)

      expect(PendingEmployee.last).to be nil
      expect(page).to have_content 'E-mail já está em uso'
      expect(current_path).to eq establishment_employees_path(owner.owned_establishment)
    end
  end
end
