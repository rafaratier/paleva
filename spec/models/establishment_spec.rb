require 'rails_helper'

describe Establishment do
  describe "#valid?" do
    let(:valid_cnpj) { CNPJ.generate(true) }

    let(:valid_user) { User.create!(
      name: 'Jeff',
      lastname: 'Bezos',
      personal_national_id: CPF.generate(true),
      email: 'jeffbezos@amazon.com',
      password: 'jeff2*6bezos')
    }

    context "with missing data" do
      it "should be false with no trade name" do
        establishment = Establishment.new(
          trade_name: '',
          legal_name: 'Pega e leva ME',
          business_national_id: valid_cnpj,
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          business_hours: {
            sunday: [],
            monday: [ '12:00', '20:00' ],
            tuesday: [ '12:00', '20:00' ],
            wednesday: [ '12:00', '20:00' ],
            thursday: [ '12:00', '20:00' ],
            friday: [ '12:00', '22:00' ],
            saturday: [ '12:00', '22:00' ] },
          owner: valid_user
        )

        expect(establishment.valid?).to be false
      end

      it "should be false with no legal name" do
        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: '',
          business_national_id: valid_cnpj,
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          business_hours: {
            sunday: [],
            monday: [ '12:00', '20:00' ],
            tuesday: [ '12:00', '20:00' ],
            wednesday: [ '12:00', '20:00' ],
            thursday: [ '12:00', '20:00' ],
            friday: [ '12:00', '22:00' ],
            saturday: [ '12:00', '22:00' ] },
          owner: valid_user
        )

        expect(establishment.valid?).to be false
      end

      it "should be false with no business national id" do
        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: '',
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          business_hours: {
            sunday: [],
            monday: [ '12:00', '20:00' ],
            tuesday: [ '12:00', '20:00' ],
            wednesday: [ '12:00', '20:00' ],
            thursday: [ '12:00', '20:00' ],
            friday: [ '12:00', '22:00' ],
            saturday: [ '12:00', '22:00' ] },
          owner: valid_user
        )

        expect(establishment.valid?).to be false
      end

      it "should be false with no phone" do
        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: valid_cnpj,
          phone: '',
          email: 'contato@paleva.com.br',
          business_hours: {
            sunday: [],
            monday: [ '12:00', '20:00' ],
            tuesday: [ '12:00', '20:00' ],
            wednesday: [ '12:00', '20:00' ],
            thursday: [ '12:00', '20:00' ],
            friday: [ '12:00', '22:00' ],
            saturday: [ '12:00', '22:00' ] },
          owner: valid_user
        )

        expect(establishment.valid?).to be false
      end

      it "should be false with no email" do
        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: valid_cnpj,
          phone: '0123456789',
          email: '',
          business_hours: {
            sunday: [],
            monday: [ '12:00', '20:00' ],
            tuesday: [ '12:00', '20:00' ],
            wednesday: [ '12:00', '20:00' ],
            thursday: [ '12:00', '20:00' ],
            friday: [ '12:00', '22:00' ],
            saturday: [ '12:00', '22:00' ] },
          owner: valid_user
        )

        expect(establishment.valid?).to be false
      end

      it "should be false with no business hours" do
        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: valid_cnpj,
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          business_hours: nil,
          owner: valid_user
        )

        expect(establishment.valid?).to be false
      end

      it "should be false with no owner" do
        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: valid_cnpj,
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          business_hours: {
            sunday: [],
            monday: [ '12:00', '20:00' ],
            tuesday: [ '12:00', '20:00' ],
            wednesday: [ '12:00', '20:00' ],
            thursday: [ '12:00', '20:00' ],
            friday: [ '12:00', '22:00' ],
            saturday: [ '12:00', '22:00' ] },
          owner: nil
        )

        expect(establishment.valid?).to be false
      end

      it "should be true with no address" do
        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: valid_cnpj,
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          business_hours: {
            sunday: [],
            monday: [ '12:00', '20:00' ],
            tuesday: [ '12:00', '20:00' ],
            wednesday: [ '12:00', '20:00' ],
            thursday: [ '12:00', '20:00' ],
            friday: [ '12:00', '22:00' ],
            saturday: [ '12:00', '22:00' ] },
          owner: valid_user,
          address: nil
        )

        expect(establishment.valid?).to be true
      end

      it "should be false when business hours is missing days of the week" do
        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: valid_cnpj,
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          business_hours: {
            tuesday: [ '12:00', '20:00' ],
            wednesday: [ '12:00', '20:00' ],
            thursday: [ '12:00', '20:00' ],
            friday: [ '12:00', '22:00' ],
            saturday: [ '12:00', '22:00' ] },
          owner: valid_user,
          address: nil
        )

        expect(establishment.valid?).to be true
        expect(establishment.errors[:business_hours]).to include("must include all weekdays: sunday, monday, tuesday, wednesday, thursday, friday, saturday")
      end
    end

    context "with wrong data" do
      it "should be false when trade name is too short" do
        establishment = Establishment.new(
          trade_name: 'P',
          legal_name: 'Pega e leva ME',
          business_national_id: valid_cnpj,
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          business_hours: {
            sunday: [],
            monday: [ '12:00', '20:00' ],
            tuesday: [ '12:00', '20:00' ],
            wednesday: [ '12:00', '20:00' ],
            thursday: [ '12:00', '20:00' ],
            friday: [ '12:00', '22:00' ],
            saturday: [ '12:00', '22:00' ] },
          owner: valid_user
        )

        expect(establishment.valid?).to be false
        expect(establishment.trade_name.length).to be < 2
      end

      it "should be false when trade name is too large" do
        establishment = Establishment.new(
          trade_name: 'Palevaaaaaaaaaaaaaaaaaaaaa',
          legal_name: 'Pega e leva ME',
          business_national_id: valid_cnpj,
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          business_hours: {
            sunday: [],
            monday: [ '12:00', '20:00' ],
            tuesday: [ '12:00', '20:00' ],
            wednesday: [ '12:00', '20:00' ],
            thursday: [ '12:00', '20:00' ],
            friday: [ '12:00', '22:00' ],
            saturday: [ '12:00', '22:00' ] },
          owner: valid_user
        )

        expect(establishment.valid?).to be false
        expect(establishment.trade_name.length).to be > 25
      end

      it "should be false when legal name is too short" do
        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'P',
          business_national_id: valid_cnpj,
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          business_hours: {
            sunday: [],
            monday: [ '12:00', '20:00' ],
            tuesday: [ '12:00', '20:00' ],
            wednesday: [ '12:00', '20:00' ],
            thursday: [ '12:00', '20:00' ],
            friday: [ '12:00', '22:00' ],
            saturday: [ '12:00', '22:00' ] },
          owner: valid_user
        )

        expect(establishment.valid?).to be false
        expect(establishment.legal_name.length).to be < 2
      end

      it "should be false when legal name is too large" do
        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva MEEEEEEEEEEEEE',
          business_national_id: valid_cnpj,
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          business_hours: {
            sunday: [],
            monday: [ '12:00', '20:00' ],
            tuesday: [ '12:00', '20:00' ],
            wednesday: [ '12:00', '20:00' ],
            thursday: [ '12:00', '20:00' ],
            friday: [ '12:00', '22:00' ],
            saturday: [ '12:00', '22:00' ] },
          owner: valid_user
        )

        expect(establishment.valid?).to be false
        expect(establishment.legal_name.length).to be > 25
      end

      it "should be false when CNPJ is too short" do
        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: '12345',
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          business_hours: {
            sunday: [],
            monday: [ '12:00', '20:00' ],
            tuesday: [ '12:00', '20:00' ],
            wednesday: [ '12:00', '20:00' ],
            thursday: [ '12:00', '20:00' ],
            friday: [ '12:00', '22:00' ],
            saturday: [ '12:00', '22:00' ] },
          owner: valid_user
        )

        expect(establishment.valid?).to be false
        expect(establishment.trade_name.length).to be < 18
      end

      it "should be false when CNPJ is too large" do
        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: 'UM_CNPJ_MUITO_GRANDE',
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          business_hours: {
            sunday: [],
            monday: [ '12:00', '20:00' ],
            tuesday: [ '12:00', '20:00' ],
            wednesday: [ '12:00', '20:00' ],
            thursday: [ '12:00', '20:00' ],
            friday: [ '12:00', '22:00' ],
            saturday: [ '12:00', '22:00' ] },
          owner: valid_user
        )

        expect(establishment.valid?).to be false
        expect(establishment.trade_name.length).to be > 18
      end

      it "should be false when phone is too short" do
        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: valid_cnpj,
          phone: '123456789',
          email: 'contato@paleva.com.br',
          business_hours: {
            sunday: [],
            monday: [ '12:00', '20:00' ],
            tuesday: [ '12:00', '20:00' ],
            wednesday: [ '12:00', '20:00' ],
            thursday: [ '12:00', '20:00' ],
            friday: [ '12:00', '22:00' ],
            saturday: [ '12:00', '22:00' ] },
          owner: valid_user
        )

        expect(establishment.valid?).to be false
        expect(establishment.phone.length).to be < 10
      end

      it "should be false when phone is too large" do
        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: valid_cnpj,
          phone: '012345678910',
          email: 'contato@paleva.com.br',
          business_hours: {
            sunday: [],
            monday: [ '12:00', '20:00' ],
            tuesday: [ '12:00', '20:00' ],
            wednesday: [ '12:00', '20:00' ],
            thursday: [ '12:00', '20:00' ],
            friday: [ '12:00', '22:00' ],
            saturday: [ '12:00', '22:00' ] },
          owner: valid_user
        )

        expect(establishment.valid?).to be false
        expect(establishment.trade_name.length).to be > 11
      end

      it "should be false when email is invalid" do
        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: valid_cnpj,
          phone: '0123456789',
          email: '@paleva.com.br',
          business_hours: {
            sunday: [],
            monday: [ '12:00', '20:00' ],
            tuesday: [ '12:00', '20:00' ],
            wednesday: [ '12:00', '20:00' ],
            thursday: [ '12:00', '20:00' ],
            friday: [ '12:00', '22:00' ],
            saturday: [ '12:00', '22:00' ] },
          owner: valid_user
        )

        expect(establishment.valid?).to be false
      end

      it "should be false when business hours is not a hash with week days as keys" do
        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: valid_cnpj,
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          business_hours: [
            sunday: [],
            monday: [ '12:00', '20:00' ],
            tuesday: [ '12:00', '20:00' ],
            wednesday: [ '12:00', '20:00' ],
            thursday: [ '12:00', '20:00' ],
            friday: [ '12:00', '22:00' ],
            saturday: [ '12:00', '22:00' ] ],
          owner: valid_user
        )

        expect(establishment.valid?).to be false
        expect(establishment.business_hours.is_a?(Hash)).not_to be true
      end

            it "should be false when business hours is not a hash with week days as keys" do
        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: valid_cnpj,
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          business_hours: [
            sunday: [],
            monday: [ '12:00', '20:00' ],
            tuesday: [ '12:00', '20:00' ],
            wednesday: [ '12:00', '20:00' ],
            thursday: [ '12:00', '20:00' ],
            friday: [ '12:00', '22:00' ],
            saturday: [ '12:00', '22:00' ] ],
          owner: valid_user
        )

        expect(establishment.valid?).to be false
        expect(establishment.business_hours.is_a?(Hash)).not_to be true
      end
    end

    context "with correct data" do
      it "should be true" do
        establishment = Establishment.new(
          trade_name: 'Paleva',
          legal_name: 'Pega e leva ME',
          business_national_id: valid_cnpj,
          phone: '0123456789',
          email: 'contato@paleva.com.br',
          business_hours: {
            sunday: [],
            monday: [ '12:00', '20:00' ],
            tuesday: [ '12:00', '20:00' ],
            wednesday: [ '12:00', '20:00' ],
            thursday: [ '12:00', '20:00' ],
            friday: [ '12:00', '22:00' ],
            saturday: [ '12:00', '22:00' ] },
          owner: valid_user
        )

        expect(establishment.valid?).to be true
      end
    end
  end
end
