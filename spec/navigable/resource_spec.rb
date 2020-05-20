RSpec.describe Navigable::Resource do
  subject(:resource) { described_class.new(router, namespaces, resource_name) }

  let(:router) { instance_double(HttpRouter, call: true) }
  let(:namespaces) { [:posts, :authors] }
  let(:resource_name) { :avatars }
  let(:route_klasses) { [Navigable::Index, Navigable::Show, Navigable::Create, Navigable::Update, Navigable::Delete] }
  let(:routes) { route_klasses.map { |klass| instance_double(klass, load:true)} }

  before do
    route_klasses.each_with_index do |klass, index|
      allow(klass).to receive(:new).and_return(routes[index])
    end
  end

  describe '#add' do
    subject(:add) { resource.add }

    before { add }

    it 'adds a resource' do
      expect(route_klasses).to all(have_received(:new).with(router, namespaces, resource_name))
    end
  end

  describe '#load' do
    subject(:load) { resource.load }

    before do
      resource.add

      load
    end

    it 'delegates to the Route objects' do
      expect(routes).to all(have_received(:load))
    end
  end
end