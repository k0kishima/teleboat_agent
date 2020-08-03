require 'rails_helper'

RSpec.describe BettingNumber, type: :model do
  describe 'validation' do
    subject { betting_number }

    context 'when first digit is unexist boat number' do
      let(:betting_number) { BettingNumber.new(number: 723) }

      it { is_expected.to be_invalid }
    end

    context 'when second digit is unexist boat number' do
      let(:betting_number) { BettingNumber.new(number: 102) }

      it { is_expected.to be_invalid }
    end

    context 'when third digit is unexist boat number' do
      let(:betting_number) { BettingNumber.new(number: 128) }

      it { is_expected.to be_invalid }
    end

    context 'when digit length is not 3' do
      let(:betting_number) { BettingNumber.new(number: 1234) }

      it { is_expected.to be_invalid }
    end

    context 'same number appeard repeatedly on per digit' do
      let(:betting_number) { BettingNumber.new(number: 121) }

      it { is_expected.to be_invalid }
    end
  end

  describe '#to_i' do
    subject { betting_number.to_i }

    context 'when object is valid' do
      let(:betting_number) { BettingNumber.new(number: 123) }

      it 'returns number' do
        expect(subject).to eq 123
      end
    end

    context 'when object is invalid' do
      let(:betting_number) { BettingNumber.new(number: 723) }

      it 'raises an exception' do
        expect { subject }.to raise_error(StandardError)
      end
    end
  end
end
