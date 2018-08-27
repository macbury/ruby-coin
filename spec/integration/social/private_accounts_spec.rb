# frozen_string_literal: true

RSpec.describe RubyCoin::Social::PrivateAccount do
  let(:private_key) { 'BC5BF3BE0DD04690D39E2336F4BC81B24E4603FC1C660FF3BA93C2B77A7F3DCD' }
  let(:public_key) { '04558064AC89B8730DF551058FA01C59B766208A4E8576E1436DE653028FEC75588BC0D392755948E6B1C6DA352F655ECC568C8DE452C6719978B3241ABA056767' }

  describe 'sign and verify' do
    subject { described_class.new(private_key: private_key, public_key: public_key) }
    let(:public_account) { RubyCoin::Social::PublicAccount.new(public_key: public_key) }
    let(:data) { 'test' }
    let(:signature) { subject.sign(data) }

    context 'the same public key' do
      it { expect(public_account.address).to eq(subject.address) }
      it { expect(public_account.verify(signature, data)).to eq(true) }
    end

    context 'other key' do
      let(:other_public_key) { RubyCoin::Crypto::Keys.generate[:public_key] }
      let(:other_account) { RubyCoin::Social::PublicAccount.new(public_key: other_public_key) }

      it { expect(other_account.address).not_to eq(subject.address) }
      it { expect(other_account.verify(signature, data)).to eq(false) }
    end

    context 'other data' do
      it { expect(public_account.verify(signature, 'test2')).to eq(false) }
    end
  end
end
