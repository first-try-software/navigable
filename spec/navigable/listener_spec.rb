require_relative '../../lib/navigable/listener'

RSpec.describe Navigable::Listener do
  subject(:listener) { described_class }

  describe '.listen_to_all_actions' do
    subject(:listen_to_all_actions) { listener.listen_to_all_actions }

    before do
      allow(Navigable::Action).to receive(:add_default_listener)

      listen_to_all_actions
    end

    it 'delegates management of default listeners to Navigable::Action' do
      expect(Navigable::Action).to have_received(:add_default_listener).with(listener)
    end
  end

  describe '.listen_to' do
    subject(:listen_to) { listener.listen_to(action) }

    let(:action) { Class.new { extend Navigable::Action } }

    before do
      allow(action).to receive(:add_listener)

      listen_to
    end

    it 'delegates management of listeners to actual action object' do
      expect(action).to have_received(:add_listener).with(listener)
    end
  end
end
