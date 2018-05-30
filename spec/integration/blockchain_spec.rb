# frozen_string_literal: true

RSpec.describe RubyCoin::Blockchain do
  subject { described_class.new }
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
