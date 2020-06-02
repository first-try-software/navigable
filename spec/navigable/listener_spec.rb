require_relative '../../lib/navigable/listener'

RSpec.describe Navigable::Listener do
  subject(:listener) { described_class }

  describe '.add_default_listener' do
    subject(:add_default_listener) { listener.add_default_listener }

    before do
      allow(Navigable::Command).to receive(:add_default_listener)

      add_default_listener
    end

    it 'delegates management of default listeners to Navigable::Command' do
      expect(Navigable::Command).to have_received(:add_default_listener).with(listener)
    end
  end

  describe '.add_listener' do
    subject(:add_listener) { listener.add_listener(command) }

    let(:command) { Class.new { extend Navigable::Command } }

    before do
      allow(command).to receive(:add_listener)

      add_listener
    end

    it 'delegates management of listeners to actual command object' do
      expect(command).to have_received(:add_listener).with(listener)
    end
  end
end
