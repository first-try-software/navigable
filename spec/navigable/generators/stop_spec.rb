RSpec.describe Navigable::Generators::Stop do
  subject(:generator) { described_class.new }

  describe '#start_server' do
    subject(:stop_server) { generator.stop_server }

    before do
      allow(generator).to receive(:puts)
      allow(generator).to receive(:run)

      stop_server
    end

    it 'prints a message' do
      expect(generator).to have_received(:puts).with(a_kind_of(String))
    end

    it 'starts the server' do
      expect(generator).to have_received(:run).with('kill -9 `cat navigable.PID`; rm navigable.PID', verbose: false)
    end
  end
end