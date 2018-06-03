# frozen_string_literal: true

RSpec.describe RubyCoin::Crypto::Merkle::Tree do
  subject { described_class.new(hashes) }

  describe 'single element' do
    let(:root) { '0007fc1c231ec1d827f757d1da8fbf594883564d098303dd6fbd46a6fe651b3c' }
    let(:hashes) { [root] }

    it { expect(subject.root.hash).to eq(root) }
  end

  describe 'noice tree' do
    let(:hashes) do
      [
        '5398a2b54c3cca6279518823862974d1746c33d193b835db0dbe1ef374c17f04',
        'ec6519f3cf75a2ed67874b9204f6710f696b87d2f36ca17113949f8499034b56',
        '4110b268936014d8cca1ec90e9b86dd2c425d4b1afbb5ad5a3320a57eeb8cc11',
        'f04ab24a1a13c9b50ccabb1601b1ec0aeb80958ee94364996f85fae53bc4f727',
        '0a4cc76f1854b50fba1eb0263f1e082dca5c330606623e4bd2478cbb72712762',
        '59b2d5d43dec4e2bc2569fd957ab2eba31a04d5784d5c043065e52f03d3a8db3',
        '3872a0614e720887f4b849f1afa11c5ecbc32d97c4128c5ae6075d1c573496a1',
        '1fcdd3a2588a088e7a8e33011a1a17d308b92c4105b703805abc0fb6a894b660',
        '458e02b1d6598dbbd7996ad5cc5b777d0796b286e26f18db00de218a590eea6f',
        '76b161fbdd2d559b95196f4d046b840d4ce2c136e2a7ae8039e437ba9a9831e9'
      ]
    end

    it { expect(subject.root.hash).to eq('3ee9e2e8ebd72ee03bdb59e7aefff36c5a6fd1688363006bfd6e0f132887e747') }
  end
end
