RSpec.describe Navigable::Resources do
  subject(:resources) { described_class.new(router) }

  let(:router) { instance_double(HttpRouter, call: true) }
  let(:resource) { instance_double(Navigable::Resource, add: true) }

  describe 'adding resources and namespaces' do
    subject(:add_namespaced_resource) do
      resources.namespace(:posts) do
        namespace(:authors) do
          add(:avatars)
        end
      end
    end

    before do
      allow(Navigable::Resource).to receive(:new).and_return(resource)

      add_namespaced_resource
    end

    it 'delegates to Resource.add with the correct namespaces and resource' do
      expect(Navigable::Resource).to have_received(:new).with(router, [:posts, :authors], :avatars)
      expect(resource).to have_received(:add)
    end
  end

  describe '#load' do
    subject(:load) { resources.load }

    let(:resource_objects) do
      [
        instance_double(Navigable::Resource, load: true, add: true),
        instance_double(Navigable::Resource, load: true, add: true),
        instance_double(Navigable::Resource, load: true, add: true)
      ]
    end

    before do
      allow(Navigable::Resource).to receive(:new).and_return(*resource_objects)

      resources.add(:posts)
      resources.namespace(:posts) do
        add(:authors)
        namespace(:authors) do
          add(:avatars)
        end
      end

      load
    end

    it 'delegates to the Resource objects' do
      expect(resource_objects).to all(have_received(:load))
    end
  end
end
