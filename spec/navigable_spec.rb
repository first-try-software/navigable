RSpec.describe Navigable do
  before do
    allow(Rack::Builder).to receive(:new).and_call_original
  end

  it 'has a version number' do
    expect(Navigable::VERSION).not_to be nil
  end

  it 'creates a new application' do
    Navigable.application

    expect(Rack::Builder).to have_received(:new).with(a_kind_of(Navigable::Application))
  end

  it 'returns same application every time' do
    expect(Navigable.application).to eq(Navigable.application)
  end
end
