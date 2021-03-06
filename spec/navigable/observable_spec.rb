RSpec.describe Navigable::Observable do
  let(:observable) { observable_klass.new }

  context 'when the observable class does NOT implement observers' do
    subject(:observable_klass) { Class.new { include Navigable::Observable } }

    it 'raises an error' do
      expect { observable.observers }.to raise_error(NotImplementedError)
    end
  end

  context 'when the observable class does NOT implement resolver' do
    subject(:observable_klass) { Class.new { include Navigable::Observable } }

    it 'raises an error' do
      expect { observable.resolver }.to raise_error(NotImplementedError)
    end
  end

  context 'when the observable class implements observers AND resolver' do
    subject(:observable_klass) { Class.new { include Navigable::Observable; attr_accessor :observers, :resolver } }

    let(:args) { 'args' }
    let(:observers) { [observer1, observer2] }
    let(:observer1) { instance_double('observer') }
    let(:observer2) { instance_double('observer') }
    let(:resolver) { instance_double('resolver') }

    before do
      observable.observers = observers
      observable.resolver = resolver
    end

    shared_examples 'an observable event' do |event, handler|
      before do
        observers.each { |observer| allow(observer).to receive(handler) }
        allow(resolver).to receive(handler)

        observable.public_send(event, args)
      end

      it 'notifies observers' do
        expect(observers).to all(have_received(handler).with(args))
      end

      it 'notifies resolver' do
        expect(resolver).to have_received(handler).with(args)
      end
    end

    describe '#successfully' do
      it_behaves_like 'an observable event', :successfully, :on_success
    end

    describe '#successfully_created' do
      it_behaves_like 'an observable event', :successfully_created, :on_creation
    end

    describe '#failed_to_validate' do
      it_behaves_like 'an observable event', :failed_to_validate, :on_failure_to_validate
    end

    describe '#failed_to_find' do
      it_behaves_like 'an observable event', :failed_to_find, :on_failure_to_find
    end

    describe '#failed_to_create' do
      it_behaves_like 'an observable event', :failed_to_create, :on_failure_to_create
    end

    describe '#failed_to_update' do
      it_behaves_like 'an observable event', :failed_to_update, :on_failure_to_update
    end

    describe '#failed_to_delete' do
      it_behaves_like 'an observable event', :failed_to_delete, :on_failure_to_delete
    end

    describe '#failed' do
      it_behaves_like 'an observable event', :failed, :on_failure
    end
  end
end