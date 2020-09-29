RSpec.describe Navigable::Dispatcher do
  subject(:dispatcher) { described_class }

  describe '.dispatch' do
    subject(:dispatch) { dispatcher.dispatch(key, params: params) }

    let(:key) { :key }
    let(:params) { 'params' }
    let(:dispatcher_instance) { instance_double(described_class, dispatch: true) }

    before do
      allow(described_class).to receive(:new).and_return(dispatcher_instance)

      dispatch
    end

    it 'delegates to an instance of dispatcher' do
      expect(described_class)
        .to have_received(:new)
        .with(key, params: params, resolver: a_kind_of(Navigable::NullResolver))
      expect(dispatcher_instance)
        .to have_received(:dispatch)
    end
  end

  describe '#dispatch' do
    subject(:dispatch) { dispatcher.dispatch }

    let(:dispatcher) { described_class.new(key, params: params, resolver: resolver) }
    let(:key) { :key }
    let(:params) { 'params' }
    let(:resolver) { instance_double('resolver', resolve: true) }
    let(:observers) { [observer] }
    let(:observer) { instance_double('observer', inject: true) }
    let(:command) { instance_double('command', execute: true, inject: true) }

    before do
      allow(Manufacturable).to receive(:build_all).and_yield(observer).and_return(observers)
      allow(Manufacturable).to receive(:build_one).and_yield(command).and_return(command)
    end

    it 'delegates to the observer factory to build observers' do
      dispatch

      expect(Manufacturable)
        .to have_received(:build_all)
        .with(
          Navigable::Observer::TYPE,
          key
        )
    end

    it 'injects params into the observers' do
      dispatch

      expect(observer).to have_received(:inject).with(params: params)
    end

    it 'delegates to the command factory to build a command' do
      dispatch

      expect(Manufacturable)
        .to have_received(:build_one)
        .with(
          Navigable::Command::TYPE,
          key
        )
    end

    context 'and a command is NOT built' do
      before do
        allow(Manufacturable).to receive(:build_one).and_return(nil)
      end

      it 'raises a Navigable::Command::NotFoundError error' do
        expect { dispatch }.to raise_error(Navigable::Command::NotFoundError)
      end
    end

    context 'and a command is built' do
      before { dispatch }

      it 'injects params into the observers' do
        expect(command).to have_received(:inject).with(params: params, observers: including(observer, resolver))
      end

      it 'executes the command' do
        expect(command).to have_received(:execute)
      end

      it 'resolves the resolver' do
        expect(resolver).to have_received(:resolve)
      end
    end
  end
end