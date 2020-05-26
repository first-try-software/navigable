RSpec.describe Navigable::Generators::Server do
  subject(:generator) { described_class.new }

  describe '#start' do
    subject(:start) { generator.start }

    before do
      allow(generator).to receive(:puts)
      allow(generator).to receive(:run)

      start
    end

    it 'prints a message' do
      expect(generator).to have_received(:puts).with(a_kind_of(String))
    end

    it 'starts the server' do
      expect(generator).to have_received(:run).with('bundle exec rackup config.ru', verbose: false)
    end
  end
end