RSpec.describe Navigable::Executor do
  subject(:executor) { described_class }

  describe '#execute' do
    before do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with('CONCURRENT_OBSERVERS').and_return(concurrent)
    end

    context 'when concurrent observers are disabled' do
      let(:concurrent) { false }

      it 'runs the block on the current thread' do
        expect(executor.execute { Thread.current }).to eq(Thread.main)
      end
    end

    context 'when concurrent observers are enabled' do
      let(:concurrent) { true }

      before do
        allow(Concurrent.global_io_executor).to receive(:post).and_call_original
      end

      it 'delegates running the block to a concurrent executor' do
        executor.execute {}

        expect(Concurrent.global_io_executor).to have_received(:post)
      end

      it 'runs the block on a different thread' do
        expect(executor.execute { Thread.current }).not_to eq(Thread.main)
      end
    end
  end
end