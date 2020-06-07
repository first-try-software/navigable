require_relative '../../lib/navigable/listener'

RSpec.describe Navigable::Listener do
  subject(:listener) { described_class }

  describe '.listen_to_all_commands' do
    subject(:listen_to_all_commands) { listener.listen_to_all_commands }

    before do
      allow(Navigable::Command).to receive(:add_default_listener)

      listen_to_all_commands
    end

    it 'delegates management of default listeners to Navigable::Command' do
      expect(Navigable::Command).to have_received(:add_default_listener).with(listener)
    end
  end

  describe '.listen_to' do
    subject(:listen_to) { listener.listen_to(command) }

    let(:command) { Class.new { extend Navigable::Command } }

    before do
      allow(command).to receive(:add_listener)

      listen_to
    end

    it 'delegates management of listeners to actual command object' do
      expect(command).to have_received(:add_listener).with(listener)
    end
  end
end
