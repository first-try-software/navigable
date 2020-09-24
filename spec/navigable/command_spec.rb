RSpec.describe Navigable::Command do
  let(:command_klass) { Class.new { extend Navigable::Command } }

  describe '.extended' do
    subject(:extended_object) { command_klass.new }

    it 'defines an inject method that accepts params' do
      expect(extended_object.respond_to?(:inject)).to be(true)
    end

    it 'defines an execute method that raises an error' do
      expect { extended_object.execute }.to raise_error(NotImplementedError)
    end

    it 'defines a corresponds_to method that delegates to Manufacturable::Item with a the Navigable Command type' do
      expect { command_klass.corresponds_to(:key) }
        .to change { Manufacturable.registered_types }
        .from([])
        .to([Navigable::Command::TYPE])
    end
  end

  describe '#inject' do
    let(:command) { command_klass.new }

    context 'when params are NOT passed' do
      subject(:inject) { command.inject }

      before { inject }

      it 'params defaults to an empty hash' do
        expect(command.params).to eq({})
      end

      it 'observers defaults to an empty array' do
        expect(command.observers).to eq([])
      end
    end

    context 'when params are passed' do
      subject(:inject) { command.inject(params: params, observers: observers) }

      let(:params) { 'params' }
      let(:observers) { [observer] }
      let(:observer) { instance_double('observer') }

      before { inject }

      it 'sets params' do
        expect(command.params).to eq(params)
      end

      it 'sets observers' do
        expect(command.observers).to eq(observers)
      end
    end
  end
end
