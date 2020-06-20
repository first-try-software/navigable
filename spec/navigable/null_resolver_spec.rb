RSpec.describe Navigable::NullResolver do
  subject(:resolver) { described_class.new }

  describe '#resolve' do
    subject(:resolve) { resolver.resolve }

    it 'does not throw an exception' do
      expect { resolve }.not_to raise_error
    end
  end
end