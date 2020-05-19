require 'rack/test'

RSpec.describe Navigable do
  include Rack::Test::Methods

  it 'has a version number' do
    expect(Navigable::VERSION).not_to be nil
  end

  describe '.application' do
    let(:app) { Navigable.application }

    before do
      allow(Rack::Builder).to receive(:new).and_call_original
      allow(Navigable.app).to receive(:call).and_call_original
    end

    it 'creates a new application' do
      Navigable.application

      expect(Rack::Builder).to have_received(:new).with(a_kind_of(Navigable::Application))
    end

    it 'uses the Rack::BodyParser middleware to parse JSON' do
      post '/', { test: 'test' }.to_json, { 'CONTENT_TYPE' => 'application/json' }

      expect(Navigable.app).to have_received(:call).with(
        a_hash_including(
          'parsed_body' => a_kind_of(Hash)
        )
      )
    end
  end

  describe '.resources' do
    subject(:resources) { Navigable.resources(&input_block) }

    let(:input_block) { Proc.new {} }
    let(:app_resources) { instance_double(Navigable::Resources, instance_eval: true) }

    before do
      allow(Navigable.app).to receive(:resources).and_return(app_resources)
    end

    it 'delegates to app resources' do
      resources

      expect(app_resources).to have_received(:instance_eval) do |&block|
        expect(block).to eq(input_block)
      end
    end
  end
end
