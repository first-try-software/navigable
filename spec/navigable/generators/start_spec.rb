RSpec.describe Navigable::Generators::Start do
  subject(:generator) { described_class.new }

  describe '#start_server' do
    subject(:start_server) { generator.start_server }

    before do
      allow(generator).to receive(:puts)
      allow(generator).to receive(:run)

      start_server
    end

    it 'prints a message' do
      expect(generator).to have_received(:puts).with(a_kind_of(String))
    end

    it 'starts the server' do
      expect(generator).to have_received(:run).with('bundle exec rackup config.ru --daemonize --pid navigable.PID', verbose: false)
    end
  end
end