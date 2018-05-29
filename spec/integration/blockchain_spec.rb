# frozen_string_literal: true
RSpec.describe RubyCoin::Blockchain do
  subject { described_class.new }
  it 'build valid chain' do
    subject.first({ test: 1000 })
    subject.next({ test: 2 })
    b2 = subject.next({ test: 3 })
    subject.next({ test: 4 }, b2)
    expect(subject).not_to be_broken
  end
end
