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

  describe '#initialize' do
    context 'when params are NOT passed' do
      subject(:observer) { observer_klass.new }

      it 'defaults to an empty hash' do
        expect(observer.params).to eq({})
      end
    end

    context 'when params are passed' do
      subject(:observer) { observer_klass.new(params: params) }

      let(:params) { 'params' }

      it 'sets params' do
        expect(observer.params).to eq(params)
      end
    end
  end

  describe '#observed_command_key' do
    subject(:observed_command_key) { obeserver_instance.observed_command_key }

    let(:obeserver_instance) { Manufacturable.build(Navigable::Observer::TYPE, command_key) }
    let(:command_key) { :command_key }

    before { observer_klass.observes(command_key) }

    it 'returns the observer\'s manufacturable_item_key' do
      expect(observed_command_key).to eq(command_key)
    end
  end
end
