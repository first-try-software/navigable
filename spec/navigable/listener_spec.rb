require_relative '../../lib/navigable/listener'

RSpec.describe Navigable::Listener do
  subject(:listener) { Class.new { extend Navigable::Listener } }

  describe '.listens_to_all_actions' do
    subject(:listens_to_all_actions) { listener.listens_to_all_actions }

    before do
      allow(listener).to receive(:corresponds_to_all)

      listens_to_all_actions
    end

    it 'delegates management of default listeners to Manufacturable' do
      expect(listener).to have_received(:corresponds_to_all)
    end
  end

  describe '.listens_to' do
    subject(:listens_to) { listener.listens_to(action) }

    let(:action) { Class.new { extend Navigable::Action } }

    before do
      allow(listener).to receive(:corresponds_to)

      listens_to
    end

    it 'delegates management of listeners to Manufacturable' do
      expect(listener).to have_received(:corresponds_to).with(action, Navigable::Listener::TYPE)
    end
  end
end
