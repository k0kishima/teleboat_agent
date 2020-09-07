require 'rails_helper'

RSpec.describe Stadium, type: :model do
  describe 'validation' do
    subject { stadium }

    context 'when tel_code greater than 24' do
      let(:stadium) { Stadium.new(tel_code: 25) }

      it { is_expected.to be_invalid }
    end

    context 'when tel_code less than 1' do
      let(:stadium) { Stadium.new(tel_code: 0) }

      it { is_expected.to be_invalid }
    end

    context 'when tel_code is blank' do
      let(:stadium) { Stadium.new(tel_code: nil) }

      it { is_expected.to be_invalid }
    end
  end

  describe '#formal_tel_code' do
    subject { stadium.formal_tel_code }

    context 'when tel code is one digit' do
      let(:stadium) { Stadium.new(tel_code: 4) }

      it 'returns zero filled number by string' do
        expect(subject).to eq '04'
      end
    end

    context 'when tel code is two digit' do
      let(:stadium) { Stadium.new(tel_code: 24) }

      it 'returns tel code by string' do
        expect(subject).to eq '24'
      end
    end
  end
end
