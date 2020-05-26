RSpec.describe Navigable::Generators::Open do
  subject(:generator) { described_class.new }

  describe '#open_browser' do
    subject(:open_browser) { generator.open_browser }

    before do
      allow(generator).to receive(:puts)
      allow(generator).to receive(:run)

      open_browser
    end

    it 'prints a message' do
      expect(generator).to have_received(:puts).with(a_kind_of(String))
    end

    it 'opens the splash page' do
      expect(generator).to have_received(:run).with("open 'http://localhost:9292'", verbose: false)
    end
  end
end