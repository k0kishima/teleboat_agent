require 'rails_helper'

RSpec.describe SimpleBettingMethodNumber, type: :model do
  let(:betting_number) { BettingNumber.new(number: 654) }
  let(:simple_betting_method_number) { SimpleBettingMethodNumber.new(race_number: race_number, quantity: quantity, betting_number: betting_number) }

  describe 'validation' do
    subject { simple_betting_method_number }

    context 'when race number is invalid' do
      let(:race_number) { 13 }
      let(:quantity) { 999 }

      it { is_expected.to be_invalid }
    end

    context 'when quantity is invalid' do
      let(:race_number) { 12 }
      let(:quantity) { 1000 }

      it { is_expected.to be_invalid }
    end
  end

  describe '#to_i' do
    subject { simple_betting_method_number.to_i }

    context 'when object is valid' do
      let(:race_number) { 1 }
      let(:quantity) { 999 }

      it 'returns number' do
        expect(subject).to eq '0131654999'
      end
    end

    context 'when object is invalid' do
      let(:race_number) { 1 }
      let(:quantity) { 0 }

      it 'raises an exception' do
        expect { subject }.to raise_error(StandardError)
      end
    end
  end
end
