# frozen_string_literal: true

RSpec.describe RubyCoin::Ledger::Wallet do
  describe '.generate' do
    subject { described_class.generate }

    it { expect(subject.public_key).to match(/\A[A-F0-9]{130}\z/) }
    it { expect(subject.private_key).to match(/\A[A-F0-9]{64}\z/) }
  end
end
