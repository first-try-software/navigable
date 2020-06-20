RSpec.shared_examples 'an observer' do
  it 'includes on_success' do
    expect(observer).to respond_to(:on_success)
  end

  it 'includes on_failure_to_validate' do
    expect(observer).to respond_to(:on_failure_to_validate)
  end

  it 'includes on_failure_to_find' do
    expect(observer).to respond_to(:on_failure_to_find)
  end

  it 'includes on_failure_to_create' do
    expect(observer).to respond_to(:on_failure_to_create)
  end

  it 'includes on_failure_to_update' do
    expect(observer).to respond_to(:on_failure_to_update)
  end

  it 'includes on_failure_to_delete' do
    expect(observer).to respond_to(:on_failure_to_delete)
  end

  it 'includes on_failure' do
    expect(observer).to respond_to(:on_failure)
  end
end
