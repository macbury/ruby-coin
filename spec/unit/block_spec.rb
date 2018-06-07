# frozen_string_literal: true

RSpec.describe RubyCoin::Block do
  describe 'attributes' do
    subject { described_class }
    it { is_expected.to have_attribute(:index) }
    it { is_expected.to have_attribute(:hash) }
    it { is_expected.to have_attribute(:prev_hash) }
    it { is_expected.to have_attribute(:time) }
    it { is_expected.to have_attribute(:nonce) }
    it { is_expected.to have_attribute(:actions) }
  end

  describe '#new' do
    it 'load coinbasese' do
      block = RubyCoin::Block.new(
        hash: 'a' * 64,
        prev_hash: 'b' * 64,
        actions: [
          {
            id: '9391dd',
            action: 'coinbase',
            hash: 'c0e3da841d280cefef848c781a9adab307ab443b8a67018acb318f448e5532eb',
            amount: 5,
            recipient: '2pVkkGy97yXfuyNhWA3qEC6Yt9yJ3grMd',
            time: Time.now.utc.to_s
          }
        ],
        nonce: 1,
        index: 20,
        time: Time.now
      )

      expect(block.actions).not_to be_empty
      expect(block.actions[0]).to be_kind_of(RubyCoin::Social::Coinbase)
    end
  end

  describe '#hash' do
    it 'uses hash from attribute, not the object one...' do
      block = RubyCoin::Block.new(
        hash: 'a' * 64,
        prev_hash: 'b' * 64,
        actions: [],
        nonce: 1,
        index: 20,
        time: Time.now
      )
      expect(block.hash).to eq('a' * 64)
    end
  end

  describe '#after' do
    let(:block) { described_class.new(attributes) }
    let(:prev_block) do
      described_class.new(
        index: 1,
        prev_hash: '0' * 64,
        actions: [],
        time: Time.local(2018, 5, 11, 6, 10, 45).utc,
        hash: 'a' * 64,
        nonce: 12
      )
    end

    subject { block.after?(prev_block) }

    context 'valid' do
      let(:attributes) do
        {
          index: 2,
          prev_hash: 'a' * 64,
          actions: [],
          time: Time.local(2018, 5, 11, 6, 10, 55).utc,
          hash: 'b' * 64,
          nonce: 12
        }
      end
      it { is_expected.to eq(true) }
    end

    context 'index is invalid' do
      let(:attributes) do
        {
          index: 1,
          prev_hash: 'a' * 64,
          actions: [],
          time: Time.local(2018, 5, 11, 6, 10, 55).utc,
          hash: 'b' * 64,
          nonce: 12
        }
      end
      it { is_expected.to eq(false) }
    end

    context 'prev_hash is diffrent' do
      let(:attributes) do
        {
          index: 2,
          prev_hash: 'x' * 64,
          actions: [],
          time: Time.local(2018, 5, 11, 6, 10, 55).utc,
          hash: 'b' * 64,
          nonce: 12
        }
      end
      it { is_expected.to eq(false) }
    end

    context 'time is in past' do
      let(:attributes) do
        {
          index: 2,
          prev_hash: 'a' * 64,
          actions: [],
          time: Time.local(2010, 5, 11, 6, 10, 55).utc,
          hash: 'b' * 64,
          nonce: 12
        }
      end
      it { is_expected.to eq(false) }
    end
  end
end
