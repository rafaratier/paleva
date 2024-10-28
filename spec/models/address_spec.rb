require 'rails_helper'

describe Address do
  describe "#valid?" do
    let(:user) { User.create!(
      name: 'Jeff',
      lastname: 'Bezos',
      personal_national_id: CPF.generate(true),
      email: 'jeffbezos@amazon.com',
      password: 'jeff2*6bezos')
    }

    let(:establishment) { Establishment.create!(
      trade_name: 'Paleva',
      legal_name: 'Pega e leva ME',
      business_national_id: CNPJ.generate(true),
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
      owner: user)
    }

    context "with missing data" do
      it "should be false without street name" do
        address = Address.new(
          street_name: '',
          street_number: 10,
          neighborhood: 'Forte',
          city: 'Praia Grande',
          state: 'São Paulo',
          country: 'Brasil',
          establishment: establishment
        )

        expect(address.valid?).to be false
      end

      it "should be false without street number" do
        address = Address.new(
          street_name: 'Avenida Presidente Kennedy',
          street_number: nil,
          neighborhood: 'Forte',
          city: 'Praia Grande',
          state: 'São Paulo',
          country: 'Brasil',
          establishment: establishment
        )

        expect(address.valid?).to be false
      end

      it "should be false without neighborhood" do
        address = Address.new(
          street_name: 'Avenida Presidente Kennedy',
          street_number: 12,
          neighborhood: '',
          city: 'Praia Grande',
          state: 'São Paulo',
          country: 'Brasil',
          establishment: establishment
        )

        expect(address.valid?).to be false
      end

      it "should be false without city" do
        address = Address.new(
          street_name: 'Avenida Presidente Kennedy',
          street_number: 12,
          neighborhood: 'Forte',
          city: '',
          state: 'São Paulo',
          country: 'Brasil',
          establishment: establishment
        )

        expect(address.valid?).to be false
      end

      it "should be false without state" do
        address = Address.new(
          street_name: 'Avenida Presidente Kennedy',
          street_number: nil,
          neighborhood: 'Forte',
          city: 'Praia Grande',
          state: '',
          country: 'Brasil',
          establishment: establishment
        )

        expect(address.valid?).to be false
      end

      it "should be false without country" do
        address = Address.new(
          street_name: 'Avenida Presidente Kennedy',
          street_number: 12,
          neighborhood: 'Forte',
          city: 'Praia Grande',
          state: 'São Paulo',
          country: '',
          establishment: establishment
        )

        expect(address.valid?).to be false
      end

      it "should be false without establishment" do
        address = Address.new(
          street_name: 'Avenida Presidente Kennedy',
          street_number: 12,
          neighborhood: 'Forte',
          city: 'Praia Grande',
          state: 'São Paulo',
          country: 'Brasil',
          establishment: nil
        )

        expect(address.valid?).to be false
      end
    end

    context "with wrong data" do
      it "should be false when street name is too short" do
        address = Address.new(
          street_name: 'aa',
          street_number: 10,
          neighborhood: 'Forte',
          city: 'Praia Grande',
          state: 'São Paulo',
          country: 'Brasil',
          establishment: establishment
        )

        expect(address.valid?).to be false
        expect(address.street_name.length).to be < 3
      end

      it "should be false when street name is too large" do
        address = Address.new(
          street_name: 'aaaaaaaaaaaaaaaaaaaaaaaaaa',
          street_number: 10,
          neighborhood: 'Forte',
          city: 'Praia Grande',
          state: 'São Paulo',
          country: 'Brasil',
          establishment: establishment
        )

        expect(address.valid?).to be false
        expect(address.street_name.length).to be > 25
      end

      it "should be false when street number is not a number" do
        address = Address.new(
          street_name: 'Avenida Presidente Kennedy',
          street_number: '12',
          neighborhood: 'Forte',
          city: 'Praia Grande',
          state: 'São Paulo',
          country: 'Brasil',
          establishment: establishment
        )

        expect(address.valid?).to be false
      end

      it "should be false when neighborhood is too shot" do
        address = Address.new(
          street_name: 'Avenida Presidente Kennedy',
          street_number: 12,
          neighborhood: 'aaa',
          city: 'Praia Grande',
          state: 'São Paulo',
          country: 'Brasil',
          establishment: establishment
        )

        expect(address.valid?).to be false
        expect(address.neighborhood.length).to be < 3
      end

      it "should be false when neighborhood is too large" do
        address = Address.new(
          street_name: 'Avenida Presidente Kennedy',
          street_number: 12,
          neighborhood: 'aaaaaaaaaaaaaaaaaaaaaaaaaa',
          city: 'Praia Grande',
          state: 'São Paulo',
          country: 'Brasil',
          establishment: establishment
        )

        expect(address.valid?).to be false
        expect(address.neighborhood.length).to be > 25
      end

      it "should be false when city is too short" do
        address = Address.new(
          street_name: 'Avenida Presidente Kennedy',
          street_number: 12,
          neighborhood: 'Forte',
          city: 'aaa',
          state: 'São Paulo',
          country: 'Brasil',
          establishment: establishment
        )

        expect(address.valid?).to be false
        expect(address.city.length).to be < 3
      end

      it "should be false when city is too large" do
        address = Address.new(
          street_name: 'Avenida Presidente Kennedy',
          street_number: 12,
          neighborhood: 'Forte',
          city: 'aaaaaaaaaaaaaaaaaaaaaaaaaa',
          state: 'São Paulo',
          country: 'Brasil',
          establishment: establishment
        )

        expect(address.valid?).to be false
        expect(address.city.length).to be > 25
      end

      it "should be false when state is too short" do
        address = Address.new(
          street_name: 'Avenida Presidente Kennedy',
          street_number: 12,
          neighborhood: 'Forte',
          city: 'Praia Grande',
          state: 'aaa',
          country: 'Brasil',
          establishment: establishment
        )

        expect(address.valid?).to be false
        expect(address.state.length).to be < 3
      end

      it "should be false when state is too large" do
        address = Address.new(
          street_name: 'Avenida Presidente Kennedy',
          street_number: 12,
          neighborhood: 'Forte',
          city: 'São Paulo',
          state: 'aaaaaaaaaaaaaaaaaaaaaaaaaa',
          country: 'Brasil',
          establishment: establishment
        )

        expect(address.valid?).to be false
        expect(address.state.length).to be > 25
      end

      it "should be false when country is too short" do
        address = Address.new(
          street_name: 'Avenida Presidente Kennedy',
          street_number: 12,
          neighborhood: 'Forte',
          city: 'Praia Grande',
          state: 'São Paulo',
          country: 'aaa',
          establishment: establishment
        )

        expect(address.valid?).to be false
        expect(address.country.length).to be < 3
      end


      it "should be false when country is too large" do
        address = Address.new(
          street_name: 'Avenida Presidente Kennedy',
          street_number: 12,
          neighborhood: 'Forte',
          city: 'Praia Grande',
          state: 'São Paulo',
          country: 'aaaaaaaaaaaaaaaaaaaaaaaaaa',
          establishment: establishment
        )

        expect(address.valid?).to be false
        expect(address.country.length).to be > 25
      end
    end

    context "with correct data" do
      it "should be true" do
        address = Address.new(
          street_name: 'Avenida Presidente Kennedy',
          street_number: 10,
          neighborhood: 'Forte',
          city: 'Praia Grande',
          state: 'São Paulo',
          country: 'Brasil',
          establishment: establishment
        )

        expect(address.valid?).to be true
      end
    end
  end
end
