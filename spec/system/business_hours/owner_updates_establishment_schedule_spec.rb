require 'rails_helper'

describe 'Owner updates establishment schedule' do
  context 'when on any page' do
    it 'owner can access the schedule through the navbar links' do
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

      sunday_business_hour = owner.owned_establishment.business_hours.sunday.first

      sunday_business_hour.update!(
        day_of_week: 'sunday',
        status: 'opened',
        open_time: '12:00',
        close_time: '20:00')

      login_as(owner)
      visit root_path

      within('header') do
        click_on 'Horário de funcionamento'
      end

      expect(current_path).to eq establishment_business_hours_path(owner.owned_establishment.id)
      expect(page).to have_content 'Horários de funcionamento'
      expect(page).to have_content 'Aberto Domingo'
      expect(page).to have_content 'Abre às 12:00'
      expect(page).to have_content 'Fecha às 20:00'
    end
  end

  context 'when on the business hour edit page' do
    it 'owner can see if day is set as "opened"' do
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

      sunday_business_hour = owner.owned_establishment.business_hours.sunday.first

      sunday_business_hour.update!(
        day_of_week: 'sunday',
        status: 'opened',
        open_time: '12:00',
        close_time: '20:00')

      login_as(owner)
      visit root_path

      within('header') do
        click_on 'Horário de funcionamento'
      end

      click_on 'Aberto Domingo'

      expect(current_path).to eq edit_establishment_business_hour_path(sunday_business_hour)
      expect(page).to have_content 'Alterar horário de funcionamento'
      expect(page).to have_content 'Aberto'
      expect(page).to have_button 'Atualizar Horário de funcionamento'
    end

    it 'owner can see if day is set as "closed"' do
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

      sunday_business_hour = owner.owned_establishment
        .business_hours.sunday.first

      login_as(owner)
      visit root_path

      within('header') do
        click_on 'Horário de funcionamento'
      end

      click_on 'Domingo'

      expect(current_path).to eq edit_establishment_business_hour_path(sunday_business_hour)
      expect(page).to have_content 'Alterar horário de funcionamento'
      expect(page).to have_content 'Fechado'
      expect(page).to have_button 'Atualizar Horário de funcionamento'
    end
  end

  context 'when owner updates a days status' do
    it 'owner must be able to change day status from "opened" to "closed"' do
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
      visit root_path

      within('header') do
        click_on 'Horário de funcionamento'
      end

      click_on 'Domingo'

      click_on 'Marcar como fechado!'

      sunday_business_hour.reload

      expect(page).to have_content 'Fechado Domingo'
      expect(sunday_business_hour.first.status).to eq 'closed'
      expect(current_path).to eq establishment_business_hours_path(owner.owned_establishment.id)
    end

    it 'owner must be able to change day status from "closed" to "open"' do
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

      login_as(owner)
      visit root_path

      within('header') do
        click_on 'Horário de funcionamento'
      end

      click_on 'Domingo'

      fill_in "Abre às",	with: "12:00"
      fill_in "Fecha às",	with: "20:00"

      click_on 'Atualizar Horário de funcionamento'

      expect(page).to have_content 'Aberto Domingo'
      expect(page).to have_content 'Abre às 12:00'
      expect(page).to have_content 'Fecha às 20:00'
      expect(sunday_business_hour.first.status).to eq 'opened'
      expect(current_path).to eq establishment_business_hours_path(owner.owned_establishment.id)
    end
  end

  context "when owner updates a days business hour" do
    it "open time must predate close time" do
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

      login_as(owner)
      visit root_path

      within('header') do
        click_on 'Horário de funcionamento'
      end

      click_on 'Domingo'

      fill_in "Abre às",	with: "20:00"
      fill_in "Fecha às",	with: "12:00"

      click_on 'Atualizar Horário de funcionamento'

      expect(page).to have_content 'O horário de fechamento não pode anteceder o de abertura'
    end
  end
end
