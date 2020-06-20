RSpec.describe Navigable::Observer do
  subject(:observer_klass) { Class.new { extend Navigable::Observer } }

  let(:observer) { observer_klass.new }

  it_behaves_like 'an observer'

  describe '.observes_all_commands' do
    subject(:observes_all_commands) { observer_klass.observes_all_commands }

    before do
      allow(observer_klass).to receive(:corresponds_to_all)

      observes_all_commands
    end

    it 'delegates management of default observers to Manufacturable' do
      expect(observer_klass).to have_received(:corresponds_to_all)
    end
  end

  describe '.observes' do
    subject(:observes) { observer_klass.observes(command) }

    let(:command) { Class.new { extend Navigable::Command } }

    before do
      allow(observer_klass).to receive(:corresponds_to)

      observes
    end

    it 'delegates management of observers to Manufacturable' do
      expect(observer_klass).to have_received(:corresponds_to).with(command, Navigable::Observer::TYPE)
    end
  end
end
