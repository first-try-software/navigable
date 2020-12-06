RSpec.describe Navigable::NullResolver do
  subject(:resolver) { described_class.new }

  describe '#resolve' do
    subject(:resolve) { resolver.resolve }

    let(:result) { 'result' }

    context 'when on_success is called' do
      before do
        resolver.on_success(result)
      end

      it 'returns the value passed to on_success' do
        expect(resolve).to eq(result)
      end
    end

    context 'when on_creation is called' do
      before do
        resolver.on_creation(result)
      end

      it 'returns the value passed to on_creation' do
        expect(resolve).to eq(result)
      end
    end

    context 'when on_failure_to_find is called' do
      before do
        resolver.on_failure_to_find(result)
      end

      it 'returns the value passed to on_failure_to_find' do
        expect(resolve).to eq(result)
      end
    end

    context 'when on_failure_to_validate is called' do
      before do
        resolver.on_failure_to_validate(result)
      end

      it 'returns the value passed to on_failure_to_validate' do
        expect(resolve).to eq(result)
      end
    end

    context 'when on_failure_to_create is called' do
      before do
        resolver.on_failure_to_create(result)
      end

      it 'returns the value passed to on_failure_to_create' do
        expect(resolve).to eq(result)
      end
    end

    context 'when on_failure_to_update is called' do
      before do
        resolver.on_failure_to_update(result)
      end

      it 'returns the value passed to on_failure_to_update' do
        expect(resolve).to eq(result)
      end
    end

    context 'when on_failure_to_delete is called' do
      before do
        resolver.on_failure_to_delete(result)
      end

      it 'returns the value passed to on_failure_to_delete' do
        expect(resolve).to eq(result)
      end
    end

    context 'when on_failure is called' do
      before do
        resolver.on_failure(result)
      end

      it 'returns the value passed to on_failure' do
        expect(resolve).to eq(result)
      end
    end
  end
end