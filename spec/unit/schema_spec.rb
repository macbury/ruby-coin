# frozen_string_literal: true

RSpec.describe RubyCoin::Schema do
  describe 'Block' do
    subject { RubyCoin::Schema::Block.call(attributes) }
    before { allow(RubyCoin::Block).to receive(:difficulty_for).and_return(2) }

    context 'valid hash' do
      let(:attributes) do
        {
          index: 1,
          hash: '00' + ('a' * 62)
        }
      end

      it { expect(subject.errors[:hash]).to be_nil }
    end

    context 'invalid hash' do
      let(:attributes) do
        {
          index: 5,
          hash: '0' + ('a' * 63)
        }
      end

      it { expect(subject.errors[:hash]).to eq(['is in invalid format']) }
    end
  end
end
