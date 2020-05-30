RSpec.describe Navigable::Splash, :integration do
  describe '.call' do
    subject(:call) { described_class.call(env) }

    let(:env) { {} }

    before do
      allow(File).to receive(:read).and_call_original
    end

    it 'loads the splash file' do
      call

      expect(File).to have_received(:read).with(a_string_matching('/../../assets/splash/splash.html.erb'))
    end

    it 'returns an array with the processed splash file' do
      expect(call).to match([200, { 'Content-Type' => 'text/html' }, [a_string_matching('<html>')]])
    end
  end
end
