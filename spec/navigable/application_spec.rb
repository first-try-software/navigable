RSpec.describe Navigable::Application do
  subject(:application) { described_class.new }

  let(:router) { instance_double(Hanami::Router, call: true) }

  before do
    allow(Hanami::Router).to receive(:new).and_return(router)
  end

  describe '#call' do
    subject(:call) { application.call(env) }

    let(:env) { instance_double('env') }

    before do
      call
    end

    it 'delegates call method to Hanami::Router' do
      expect(router).to have_received(:call).with(env)
    end
  end

  describe '#router' do
    subject(:app_router) { application.router }

    it 'returns an instance of Resources' do
      expect(app_router).to be(router)
    end
  end
end