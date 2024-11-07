require 'rails_helper'

describe PendingEmployee do
  describe "#valid?" do
    context "when missing data" do
      it "should be false with no personal national id" do
        owner = User.create!(
          role: 'owner',
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: CPF.generate(true),
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos')

        establishment = Establishment.create!(
          trade_name: 'Papega',
          legal_name: 'Pega e leva ME',
          business_national_id: CNPJ.generate(true),
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          owner: owner
        )

        pending_employee = PendingEmployee.new(
          personal_national_id: '',
          email: 'billgates@outlook.com',
          establishment: establishment)

        expect(pending_employee.valid?).to be false
      end

      it "should be false with no email address" do
        owner = User.create!(
          role: 'owner',
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: CPF.generate(true),
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos')

        establishment = Establishment.create!(
          trade_name: 'Papega',
          legal_name: 'Pega e leva ME',
          business_national_id: CNPJ.generate(true),
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          owner: owner
        )

        pending_employee = PendingEmployee.new(
          personal_national_id: CPF.generate(true),
          email: '',
          establishment: establishment)

        expect(pending_employee.valid?).to be false
      end

      it "should be false with no establishment" do
        owner = User.create!(
          role: 'owner',
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: CPF.generate(true),
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos')

        Establishment.create!(
          trade_name: 'Papega',
          legal_name: 'Pega e leva ME',
          business_national_id: CNPJ.generate(true),
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          owner: owner
        )

        pending_employee = PendingEmployee.new(
          personal_national_id: CPF.generate(true),
          email: 'billgates@outlook.com')

        expect(pending_employee.valid?).to be false
      end
    end

    context "when pending employee already exists" do
      it "should be false when email is already taken" do
        owner = User.create!(
          role: 'owner',
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: CPF.generate(true),
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos')

        establishment = Establishment.create!(
          trade_name: 'Papega',
          legal_name: 'Pega e leva ME',
          business_national_id: CNPJ.generate(true),
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          owner: owner
        )

        PendingEmployee.create!(
          personal_national_id: CPF.generate(true),
          email: 'billgates@outlook.com',
          establishment: establishment)

        pending_employee = establishment.pending_employees.build(
          personal_national_id: CPF.generate(true),
          email: 'billgates@outlook.com'
        )

        expect(pending_employee.valid?).to be false
      end

      it "should be false when email is already taken" do
        owner = User.create!(
          role: 'owner',
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: CPF.generate(true),
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos')

        establishment = Establishment.create!(
          trade_name: 'Papega',
          legal_name: 'Pega e leva ME',
          business_national_id: CNPJ.generate(true),
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          owner: owner
        )

        same_personal_national_id = CPF.generate(true)

        PendingEmployee.create!(
          personal_national_id: same_personal_national_id,
          email: 'warrenbuffett@outlook.com',
          establishment: establishment)

        pending_employee = establishment.pending_employees.build(
          personal_national_id: same_personal_national_id,
          email: 'billgates@outlook.com'
        )

        expect(pending_employee.valid?).to be false
      end
    end
  end

  context "when before employee is registered" do
    it "initial status should be 'pending'" do
      owner = User.create!(
        role: 'owner',
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

      establishment = Establishment.create!(
        trade_name: 'Papega',
        legal_name: 'Pega e leva ME',
        business_national_id: CNPJ.generate(true),
        phone: '0123456789',
        email: 'contato@paleva.com.br',
        owner: owner
      )

      pending_employee = PendingEmployee.new(
        personal_national_id: CPF.generate(true),
        email: 'billgates@outlook.com',
        establishment: establishment)

      expect(pending_employee.status).to eq 'pending'
    end
  end

  context "when after employee is registered" do
    it "status should be 'registered'" do
      owner = User.create!(
        role: 'owner',
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

      establishment = Establishment.create!(
        trade_name: 'Papega',
        legal_name: 'Pega e leva ME',
        business_national_id: CNPJ.generate(true),
        phone: '0123456789',
        email: 'contato@paleva.com.br',
        owner: owner
      )

      employee_personal_national_id = CPF.generate(true)

      pending_employee = PendingEmployee.create!(
        personal_national_id: employee_personal_national_id,
        email: 'billgates@outlook.com',
        establishment: establishment)

      establishment.employees.create!(
        role: 'employee',
        name: 'Bill',
        lastname: 'Gates',
        personal_national_id: employee_personal_national_id,
        email: 'billgates@outlook.com',
        password: 'bill2*6gates')

      pending_employee.reload

      expect(pending_employee.status).to eq 'registered'
    end
  end
end
