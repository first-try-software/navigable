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
end
