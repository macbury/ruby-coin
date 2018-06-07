# frozen_string_literal: true

RSpec.describe RubyCoin::Social::ActionBuilder do
  describe '#transaction' do
    let(:sender) { RubyCoin::Social::PrivateAccount.generate }
    let(:receiver) { RubyCoin::Social::PrivateAccount.generate }
    let(:builder) { described_class.new }

    subject do
      builder.use_account(sender)
      builder.transaction(receiver.address, 10)
    end

    it { is_expected.to be_valid_hash }
    it { is_expected.to be_valid_signture }
  end
end
