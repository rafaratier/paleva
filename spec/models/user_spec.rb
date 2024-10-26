require 'rails_helper'

describe User do
  describe "#valid?" do
    let(:valid_cpf) { CPF.generate(true) }
    context "with missing data" do
      it "should be false with no name" do
        user = User.new(
          name: '',
          lastname: 'Bezos',
          personal_national_id: valid_cpf,
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos'
          )

        expect(user.valid?).to be false
      end

      it "should be false with no lastname" do
        user = User.new(
          name: 'Jeff',
          lastname: '',
          personal_national_id: valid_cpf,
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos'
          )

        expect(user.valid?).to be false
      end

      it "should be false with no personal national id" do
        user = User.new(
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: '',
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos'
          )

        expect(user.valid?).to be false
      end

      it "should be false with no email" do
        user = User.new(
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: valid_cpf,
          email: '',
          password: 'jeff2*6bezos'
          )

        expect(user.valid?).to be false
      end

      it "should be false with no password" do
        user = User.new(
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: valid_cpf,
          email: 'jeffbezos@amazon.com',
          password: ''
          )

        expect(user.valid?).to be false
      end
    end

    context "with wrong data" do
      it "should be false when name is too short" do
        user = User.new(
          name: 'J',
          lastname: 'Bezos',
          personal_national_id: valid_cpf,
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos'
          )

        expect(user.valid?).to be false
        expect(user.name.length).to be < 2
      end

      it "should be false when name is too large" do
        user = User.new(
          name: 'Jeffffffffffffffffffffffff',
          lastname: 'Bezos',
          personal_national_id: valid_cpf,
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos'
          )

        expect(user.valid?).to be false
        expect(user.name.length).to be > 25
      end

      it "should be false when lastname is too short" do
        user = User.new(
          name: 'Jeff',
          lastname: 'B',
          personal_national_id: valid_cpf,
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos'
          )

        expect(user.valid?).to be false
        expect(user.lastname.length).to be < 2
      end

      it "should be false when lastname is too large" do
        user = User.new(
          name: 'Jeff',
          lastname: 'Bezossssssssssssssssssssss',
          personal_national_id: valid_cpf,
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos'
          )

        expect(user.valid?).to be false
        expect(user.lastname.length).to be > 25
      end

      it "should be false when personal national id is too short" do
        user = User.new(
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: '12345',
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos'
          )

        expect(user.valid?).to be false
        expect(user.lastname.length).to be < 14
      end

      it "should be false when personal national id is too large" do
        user = User.new(
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: '0123.456.789-10',
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos'
          )

        expect(user.valid?).to be false
        expect(user.personal_national_id.length).to be > 14
      end

      it "should be false when email is too short" do
        user = User.new(
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: valid_cpf,
          email: '@amazon.com',
          password: 'jeff2*6bezosbezos'
          )

        expect(user.valid?).to be false
      end

      it "should be false when password is too short" do
        user = User.new(
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: valid_cpf,
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6'
          )

        expect(user.valid?).to be false
        expect(user.password.length).to be < 12
      end
    end

    context "with correct data" do
      it "should be true" do
        user = User.new(
          name: 'Jeff',
          lastname: 'Bezos',
          personal_national_id: valid_cpf,
          email: 'jeffbezos@amazon.com',
          password: 'jeff2*6bezos'
          )

        expect(user.valid?).to be true
      end
    end
  end
end
