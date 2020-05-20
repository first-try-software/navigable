module Tasks
  class Index; end
  class Show; end
  class Create; end
  class Update; end
  class Delete; end
end

module Magic
  module Markers
    class Index; end
    class Show; end
    class Create; end
    class Update; end
    class Delete; end
  end
end

module Posts
  module Authors
    module Avatars
      class Index; end
      class Show; end
      class Create; end
      class Update; end
      class Delete; end
    end
  end
end

RSpec.shared_examples 'a route' do
  subject(:route) { described_class.new(router, namespaces, resource) }

  let(:router) { instance_double(HttpRouter, call: true) }
  let(:action) { described_class.name.split('::').last.to_sym }

  before do
    allow(HttpRouter).to receive(:new).and_return(router)
  end

  describe '#load' do
    subject(:load) { route.load }

    let(:http_route) { instance_double(HttpRouter::RouteHelper, to: true) }

    before do
      allow(router).to receive(verb).and_return(http_route)

      load
    end

    context 'when there is a single resource and no namespaces' do
      let(:namespaces) { [] }
      let(:resource) { :tasks }

      it 'adds a resource' do
        expect(router).to have_received(verb).with("/tasks#{identifier}")
        expect(http_route).to have_received(:to).with(Tasks.const_get(action.capitalize))
      end
    end

    context 'when there is a single resource in a namespace' do
      let(:namespaces) { [:magic] }
      let(:resource) { :markers }

      it 'adds the resource within the namespace' do
        expect(router).to have_received(verb).with("/magic/:magic_id/markers#{identifier}")
        expect(http_route).to have_received(:to).with(Magic::Markers.const_get(action.capitalize))
      end
    end

    context 'when there is a single resource in a nested namespace' do
      let(:namespaces) { [:posts, :authors] }
      let(:resource) { :avatars }

      it 'adds the resource within the namespace' do
        expect(router).to have_received(verb).with("/posts/:posts_id/authors/:authors_id/avatars#{identifier}")
        expect(http_route).to have_received(:to).with(Posts::Authors::Avatars.const_get(action.capitalize))
      end
    end
  end
end

RSpec.describe Navigable::Index do
  let(:verb) { :get }
  let(:identifier) { '' }

  it_behaves_like 'a route'
end

RSpec.describe Navigable::Show do
  let(:verb) { :get }
  let(:identifier) { '/:id' }

  it_behaves_like 'a route'
end

RSpec.describe Navigable::Create do
  let(:verb) { :post }
  let(:identifier) { '' }

  it_behaves_like 'a route'
end

RSpec.describe Navigable::Update do
  let(:verb) { :put }
  let(:identifier) { '/:id' }

  it_behaves_like 'a route'
end
RSpec.describe Navigable::Delete do
  let(:verb) { :delete }
  let(:identifier) { '/:id' }

  it_behaves_like 'a route'
end

