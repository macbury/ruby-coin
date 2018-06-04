# frozen_string_literal: true

RSpec.describe RubyCoin::Validation::Chain do
  let(:chain) { RubyCoin::Chain.new(database_url: 'sqlite://data/blockchain.test.db') }

  before { chain.clear }
  before { allow(RubyCoin::Block).to receive(:difficulty_for).and_return(2) }

  subject { described_class.new }
  let(:miner) { RubyCoin::Miner::Master.new(chain: chain) }

  it 'build valid chain' do
    chain << miner.genesis
    10.times { |index| chain << miner.mine([]) }
    expect(subject.valid?(chain)).to eq(true)
  end

  describe 'break chain' do
    it 'totaly bogus' do
      chain << miner.genesis
      10.times { |index| chain << miner.mine([]) }
      chain << RubyCoin::Block.new(
        hash: 'a' * 64,
        prev_hash: 'b' * 64,
        data: { invalid: true },
        nonce: 1,
        index: 20,
        time: Time.now
      )
      chain << miner.mine(test: 'boo')
      expect(subject.valid?(chain)).to eq(false)
    end
  end
end
