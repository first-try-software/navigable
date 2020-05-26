RSpec.describe Navigable::Splash do
  describe '.call' do
    subject(:call) { described_class.call(env) }

    let(:env) { {} }
    let(:erb) { instance_double(ERB, result: result) }
    let(:result) { 'result' }
    let(:splash_file) { 'splash_file' }

    before do
      allow(ERB).to receive(:new).and_return(erb)
      allow(File).to receive(:read).and_return(splash_file)
    end

    it 'loads the splash file' do
      call

      expect(File).to have_received(:read).with(a_string_matching('/../../assets/splash.html.erb'))
    end

    it 'processes the splash file with ERB' do
      call

      expect(erb).to have_received(:result)
    end

    it 'returns an array with the processed splash file' do
      expect(call).to eq([200, { 'Content-Type' => 'text/html' }, [result]])
    end
  end
end