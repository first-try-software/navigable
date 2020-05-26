RSpec.describe Navigable::Generators::New do
  subject(:generator) { described_class.new(args) }

  let(:args) { [app_name] }
  let(:app_name) { 'app_name' }

  before do
    allow(generator).to receive(:puts)
    allow(generator).to receive(:run)
    allow(generator).to receive(:directory)
    allow(generator).to receive(:inside).and_yield
  end

  describe '.source_root' do
    subject(:source_root) { described_class.source_root }

    it 'returns the assets directory' do
      expect(source_root).to match('../../assets')
    end
  end

  describe '#create_new_app' do
    subject(:create_new_app) { generator.create_new_app }

    before { create_new_app }

    it 'prints a message' do
      expect(generator).to have_received(:puts).with(a_kind_of(String))
    end

    it 'copies a directory' do
      expect(generator).to have_received(:directory).with('new_app_template', app_name)
    end
  end

  describe '#bundle' do
    subject(:bundle) { generator.bundle }

    before { bundle }

    it 'prints a message' do
      expect(generator).to have_received(:puts).with(a_kind_of(String))
    end

    it 'runs bundle install inside the app directory' do
      expect(generator).to have_received(:inside).with(app_name)
      expect(generator).to have_received(:run).with('bundle install')
    end
  end

  describe '#usage' do
    subject(:usage) { generator.usage }

    before { usage }

    it 'runs navigable help' do
      expect(generator).to have_received(:run).with('navigable help', verbose: false)
    end
  end
end