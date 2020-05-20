RSpec.describe Navigable::Resources do
  subject(:resources) { described_class.new(router) }

  let(:router) { instance_double(HttpRouter, call: true) }
  let(:resource) { instance_double(Navigable::Resource, add: true) }

  let(:add_resources) do
    resources.add(:posts)
    resources.namespace(:posts) do
      add(:authors)
      namespace(:authors) do
        add(:avatars)
      end
    end
  end

  let(:resource_objects) do
    [
      instance_double(Navigable::Resource, add: true, load: true, print: true),
      instance_double(Navigable::Resource, add: true, load: true, print: true),
      instance_double(Navigable::Resource, add: true, load: true, print: true)
    ]
  end

  before do
    allow(Navigable::Resource).to receive(:new).and_return(*resource_objects)

    add_resources
  end

  describe '#add' do
    it 'delegates to Resource.add with the correct namespaces and resource' do
      expect(Navigable::Resource).to have_received(:new).with(router, [], :posts)
      expect(Navigable::Resource).to have_received(:new).with(router, [:posts], :authors)
      expect(Navigable::Resource).to have_received(:new).with(router, [:posts, :authors], :avatars)
      expect(resource_objects).to all(have_received(:add))
    end
  end

  describe '#load' do
    subject(:load) { resources.load }

    before { load }

    it 'delegates to the Resource objects' do
      expect(resource_objects).to all(have_received(:load))
    end
  end

  describe '#print' do
    subject(:print) { resources.print }

    before { print }

    it 'delegates to the Resource objects' do
      expect(resource_objects).to all(have_received(:print))
    end
  end
end
