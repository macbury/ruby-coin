# frozen_string_literal: true

RSpec.describe RubyCoin::Crypto::Keys do
  describe '#generate' do
    subject { described_class.generate }

    it { expect(subject[:public_key]).to match(/\A[A-F0-9]{130}\z/) }
    it { expect(subject[:private_key]).to match(/\A[A-F0-9]{64}\z/) }
  end

  describe 'signing and verifing' do
    let(:private_key) { 'BC5BF3BE0DD04690D39E2336F4BC81B24E4603FC1C660FF3BA93C2B77A7F3DCD' }
    let(:public_key) { '04558064AC89B8730DF551058FA01C59B766208A4E8576E1436DE653028FEC75588BC0D392755948E6B1C6DA352F655ECC568C8DE452C6719978B3241ABA056767' }
    let(:signature) { subject.dsa_sign_asn1(data) }
    let(:data) { 'my data' }
    subject { described_class.build_key(public_key, private_key) }

    context 'valid data and signature' do
      it { expect(described_class.verify(signature, public_key, data)).to eq(true) }
    end

    context 'invalid data' do
      it { expect(described_class.verify(signature, public_key, 'forged data')).to eq(false) }
    end
  end
end
