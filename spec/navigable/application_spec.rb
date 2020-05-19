RSpec.describe Navigable::Application do
  subject(:application) { described_class.new }

  let(:http_router) { instance_double(HttpRouter, call: true) }

  before do
    allow(HttpRouter).to receive(:new).and_return(http_router)
  end

  describe '#call' do
    subject(:call) { application.call(env) }

    let(:env) { instance_double('env') }

    before do
      call
    end

    it 'delegates call method to HttpRouter' do
      expect(http_router).to have_received(:call).with(env)
    end
  end
end