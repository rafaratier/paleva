require 'rails_helper'

describe Establishment do
  describe "#valid?" do
    context "with missing data" do
      it "should be false with no trade name" do
        owner = User.create!(
          role: 'owner',
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: CPF.generate(true),
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos')

        establishment = Establishment.new(
          trade_name: '',
          legal_name: 'Pega e leva ME',
          business_national_id: CNPJ.generate(true),
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          owner: owner
        )

        expect(establishment.valid?).to be false
      end

      it "should be false with no legal name" do
        owner = User.create!(
          role: 'owner',
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: CPF.generate(true),
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos')

        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: '',
          business_national_id: CNPJ.generate(true),
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          owner: owner
        )

        expect(establishment.valid?).to be false
      end

      it "should be false with no business national id" do
        owner = User.create!(
          role: 'owner',
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: CPF.generate(true),
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos')

        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: '',
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          owner: owner
        )

        expect(establishment.valid?).to be false
      end

      it "should be false with no phone" do
        owner = User.create!(
          role: 'owner',
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: CPF.generate(true),
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos')

        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: CNPJ.generate(true),
          phone: '',
          email: 'contato@paleva.com.br',
          owner: owner
        )

        expect(establishment.valid?).to be false
      end

      it "should be false with no email" do
        owner = User.create!(
          role: 'owner',
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: CPF.generate(true),
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos')

        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: CNPJ.generate(true),
          phone: '0123456789',
          email: '',
          owner: owner
        )

        expect(establishment.valid?).to be false
      end

      it "should be false with no owner" do
        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: CNPJ.generate(true),
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          owner: nil
        )

        expect(establishment.valid?).to be false
      end

      it "should be true with no address" do
        owner = User.create!(
          role: 'owner',
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: CPF.generate(true),
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos')

        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: CNPJ.generate(true),
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          owner: owner,
          address: nil
        )

        expect(establishment.valid?).to be true
      end
    end

    context "with wrong data" do
      it "should be false when trade name is too short" do
        owner = User.create!(
          role: 'owner',
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: CPF.generate(true),
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos')

        establishment = Establishment.new(
          trade_name: 'P',
          legal_name: 'Pega e leva ME',
          business_national_id: CNPJ.generate(true),
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          owner: owner
        )

        expect(establishment.valid?).to be false
        expect(establishment.trade_name.length).to be < 2
      end

      it "should be false when trade name is too large" do
        owner = User.create!(
          role: 'owner',
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: CPF.generate(true),
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos')

        establishment = Establishment.new(
          trade_name: 'Palevaaaaaaaaaaaaaaaaaaaaa',
          legal_name: 'Pega e leva ME',
          business_national_id: CNPJ.generate(true),
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          owner: owner
        )

        expect(establishment.valid?).to be false
        expect(establishment.trade_name.length).to be > 25
      end

      it "should be false when legal name is too short" do
        owner = User.create!(
          role: 'owner',
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: CPF.generate(true),
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos')

        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'P',
          business_national_id: CNPJ.generate(true),
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          owner: owner
        )

        expect(establishment.valid?).to be false
        expect(establishment.legal_name.length).to be < 2
      end

      it "should be false when legal name is too large" do
        owner = User.create!(
          role: 'owner',
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: CPF.generate(true),
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos')

        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva MEEEEEEEEEEEEE',
          business_national_id: CNPJ.generate(true),
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          owner: owner
        )

        expect(establishment.valid?).to be false
        expect(establishment.legal_name.length).to be > 25
      end

      it "should be false when CNPJ is too short" do
        owner = User.create!(
          role: 'owner',
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: CPF.generate(true),
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos')

        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: '12345',
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          owner: owner
        )

        expect(establishment.valid?).to be false
        expect(establishment.trade_name.length).to be < 18
      end

      it "should be false when CNPJ is too large" do
        owner = User.create!(
          role: 'owner',
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: CPF.generate(true),
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos')

        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: 'UM_CNPJ_MUITO_GRANDE',
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          owner: owner
        )

        expect(establishment.valid?).to be false
        expect(establishment.business_national_id.length).to be > 18
      end

      it "should be false when phone is too short" do
        owner = User.create!(
          role: 'owner',
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: CPF.generate(true),
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos')

        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: CNPJ.generate(true),
          phone: '123456789',
          email: 'contato@paleva.com.br',
          owner: owner
        )

        expect(establishment.valid?).to be false
        expect(establishment.phone.length).to be < 10
      end

      it "should be false when phone is too large" do
        owner = User.create!(
          role: 'owner',
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: CPF.generate(true),
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos')

        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: CNPJ.generate(true),
          phone: '012345678910',
          email: 'contato@paleva.com.br',
          owner: owner
        )

        expect(establishment.valid?).to be false
        expect(establishment.phone.length).to be > 11
      end

      it "should be false when email is invalid" do
        owner = User.create!(
          role: 'owner',
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: CPF.generate(true),
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos')

        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: CNPJ.generate(true),
          phone: '0123456789',
          email: '@paleva.com.br',
          owner: owner
        )

        expect(establishment.valid?).to be false
      end
    end

    context "with correct data" do
      it "should be true" do
        owner = User.create!(
          role: 'owner',
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: CPF.generate(true),
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos')

        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: CNPJ.generate(true),
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          owner: owner
        )

        expect(establishment.valid?).to be true
      end
    end
  end

  describe "Establishment alphanumeric code" do
    it "establishment code should have length 8" do
      owner = User.create!(
        role: 'owner',
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: CPF.generate(true),
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos')

      establishment = Establishment.create!(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: CNPJ.generate(true),
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          owner: owner
        )

      expect(establishment.code.length).to eq 10
    end

    it "establishment code should be unique" do
      owner = User.create!(
        role: 'owner',
        name: 'Jeff',
        lastname: 'Bezos',
        personal_national_id: CPF.generate(true),
        email: 'jeffbezos@amazon.com',
        password: 'jeff2*6bezos')

      establishment = Establishment.create!(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: CNPJ.generate(true),
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          owner: owner
        )

      other_user = User.create!(
        role: 'owner',
        name: 'Bill',
        lastname: 'Gates',
        personal_national_id: CPF.generate(true),
        email: 'billgates@amazon.com',
        password: 'bill2*6gates')

      other_establishment = Establishment.create!(
        trade_name: 'Receba',
        legal_name: 'Peça e Receba ME',
        business_national_id: CNPJ.generate(true),
        phone: '9876543210',
        email: 'contato@receba.com.br',
        owner: other_user
      )

      expect(other_establishment.code).not_to eq establishment.code
    end
  end
end
