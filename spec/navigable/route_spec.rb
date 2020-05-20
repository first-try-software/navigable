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

  describe '#print' do
    subject(:print) { route.print }

    before do
      allow(route).to receive(:puts)

      print
    end

    context 'when there is a single resource and no namespaces' do
      let(:namespaces) { [] }
      let(:resource) { :tasks }

      it 'prints a route' do
        expect(route).to have_received(:puts).with(route_output)
      end
    end

    context 'when there is a single resource in a namespace' do
      let(:namespaces) { [:magic] }
      let(:resource) { :markers }

      it 'adds the resource within the namespace' do
        expect(route).to have_received(:puts).with(namespaced_route_output)
      end
    end

    context 'when there is a single resource in a nested namespace' do
      let(:namespaces) { [:posts, :authors] }
      let(:resource) { :avatars }

      it 'adds the resource within the namespace' do
        expect(route).to have_received(:puts).with(nested_namespaced_route_output)
      end
    end
  end
end

RSpec.describe Navigable::Index do
  let(:verb) { :get }
  let(:identifier) { '' }
  let(:route_output) { '     GET /tasks  =>  Tasks::Index' }
  let(:namespaced_route_output) { '     GET /magic/:magic_id/markers  =>  Magic::Markers::Index' }
  let(:nested_namespaced_route_output) { '     GET /posts/:posts_id/authors/:authors_id/avatars  =>  Posts::Authors::Avatars::Index' }

  it_behaves_like 'a route'
end

RSpec.describe Navigable::Show do
  let(:verb) { :get }
  let(:identifier) { '/:id' }
  let(:route_output) { '     GET /tasks/:id  =>  Tasks::Show' }
  let(:namespaced_route_output) { '     GET /magic/:magic_id/markers/:id  =>  Magic::Markers::Show' }
  let(:nested_namespaced_route_output) { '     GET /posts/:posts_id/authors/:authors_id/avatars/:id  =>  Posts::Authors::Avatars::Show' }

  it_behaves_like 'a route'
end

RSpec.describe Navigable::Create do
  let(:verb) { :post }
  let(:identifier) { '' }
  let(:route_output) { '    POST /tasks  =>  Tasks::Create' }
  let(:namespaced_route_output) { '    POST /magic/:magic_id/markers  =>  Magic::Markers::Create' }
  let(:nested_namespaced_route_output) { '    POST /posts/:posts_id/authors/:authors_id/avatars  =>  Posts::Authors::Avatars::Create' }

  it_behaves_like 'a route'
end

RSpec.describe Navigable::Update do
  let(:verb) { :put }
  let(:identifier) { '/:id' }
  let(:route_output) { '     PUT /tasks/:id  =>  Tasks::Update' }
  let(:namespaced_route_output) { '     PUT /magic/:magic_id/markers/:id  =>  Magic::Markers::Update' }
  let(:nested_namespaced_route_output) { '     PUT /posts/:posts_id/authors/:authors_id/avatars/:id  =>  Posts::Authors::Avatars::Update' }

  it_behaves_like 'a route'
end
RSpec.describe Navigable::Delete do
  let(:verb) { :delete }
  let(:identifier) { '/:id' }
  let(:route_output) { '  DELETE /tasks/:id  =>  Tasks::Delete' }
  let(:namespaced_route_output) { '  DELETE /magic/:magic_id/markers/:id  =>  Magic::Markers::Delete' }
  let(:nested_namespaced_route_output) { '  DELETE /posts/:posts_id/authors/:authors_id/avatars/:id  =>  Posts::Authors::Avatars::Delete' }

  it_behaves_like 'a route'
end

