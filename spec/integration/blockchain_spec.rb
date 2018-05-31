# frozen_string_literal: true

RSpec.describe RubyCoin::Blockchain do
  let(:chain) { RubyCoin::Chain.new({ database_url: 'sqlite://data/blockchain.test.db' }) }
  before { chain.clear }
  before { allow(RubyCoin::Block).to receive(:difficulty_for).and_return(2) }

  subject { described_class.new(chain: chain) }

  it 'build valid chain' do
    subject << { test: 1000 }
    subject << { test: 2 }
    subject << { test: 3 }
    subject << { test: 4 }
    expect(subject).not_to be_broken
  end

  describe 'break chain' do
    it 'totaly bogus' do
      subject << { test: 1000 }
      subject.chain << RubyCoin::Block.new(
        hash: 'a' * 64,
        prev_hash: 'b' * 64,
        data: { invalid: true },
        nonce: 1,
        index: 20,
        time: Time.now
      )
      subject << { test: 2 }
      expect(subject).to be_broken
    end
  end
end
