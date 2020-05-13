RSpec.describe Navigable do
  it 'has a version number' do
    expect(Navigable::VERSION).not_to be nil
  end

  it 'creates a new application' do
    expect(Navigable.application).to be_a_kind_of(Navigable::Application)
  end

  it 'returns same application every time' do
    expect(Navigable.application).to eq(Navigable.application)
  end
end
