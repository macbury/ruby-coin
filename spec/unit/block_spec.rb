# frozen_string_literal: true

RSpec.describe RubyCoin::Block do
  describe '.first' do
    subject { described_class.first({}) }

    it { expect(subject.data).to eq({}) }
    it 'creates genesis block' do
      expect(subject.prev_hash).to eq('0'*64)
    end
  end

  describe '.next' do
    let(:prev_block) { described_class.first({}) }
    subject { described_class.next(prev_block, {}) }

    it { expect(subject.data).to eq({}) }
    it { expect(subject.prev_hash).to eq(prev_block.hash) }
  end

  describe '#new' do
    before { Timecop.freeze(Time.local(2018)) }
    subject { described_class.new(attributes) }
    after { Timecop.return }

    context 'with already calculated proof of concept' do
      let(:attributes) do
        {
          data: { a: 'b' },
          prev_hash: '0',
          nonce: 443,
          time: Time.now,
          difficulty: 2
        }
      end

      it { expect(subject.data).to eq(a: 'b') }
      it { expect(subject.nonce).to eq(443) }
      it { expect(subject.hash).to eq('00e07f9661f9defbf9f82c8518d5499db43ce973bb6fffdf329b6fdad50dbaeb') }
      it { expect(subject.prev_hash).to eq('0') }
      it { expect(subject).to be_valid }
    end

    context 'with need to calculate proof of work' do
      let(:attributes) do
        {
          data: { a: 'b' },
          prev_hash: 'abc',
          difficulty: 2
        }
      end

      it { expect(subject.nonce).to eq(670) }
      it { expect(subject.hash).to eq('003cfa9477241ee44c3b2ec64a5fb208c54a2e5185438afedc5cfe824147b0f0') }
    end
  end
end
