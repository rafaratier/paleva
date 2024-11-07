require 'rails_helper'

describe "User sign out" do
  it "should redirect to sign in page" do
    user = User.create!(
    name: 'Jeff',
    lastname: 'Bezos',
    personal_national_id: CPF.generate(true),
    email: 'jeffbezos@amazon.com',
    password: 'jeff2*6bezos')

    login_as(user)
    visit root_path

    within('header') do
      click_on 'Sair'
    end

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Entrar'
    expect(page).not_to have_content 'Jeff Bezos'
  end
end
