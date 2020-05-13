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

  describe '#resources' do
    subject(:resources) { application.resources &routes }

    let(:index_route)  { instance_double(HttpRouter::RouteHelper, to: true) }
    let(:show_route)   { instance_double(HttpRouter::RouteHelper, to: true) }
    let(:create_route) { instance_double(HttpRouter::RouteHelper, to: true) }
    let(:update_route) { instance_double(HttpRouter::RouteHelper, to: true) }
    let(:delete_route) { instance_double(HttpRouter::RouteHelper, to: true) }

    before do
      allow(http_router).to receive(:get).and_return(index_route)
      allow(http_router).to receive(:get).with(a_string_matching('/:id')).and_return(show_route)
      allow(http_router).to receive(:post).and_return(create_route)
      allow(http_router).to receive(:put).and_return(update_route)
      allow(http_router).to receive(:delete).and_return(delete_route)

      resources
    end

    context 'when there is a single resource and no namespaces' do
      let(:routes) { Proc.new { add :tasks } }

      it 'adds a resource' do
        expect(http_router).to have_received(:get).with('/tasks')
        expect(index_route).to have_received(:to).with(Tasks::Index)

        expect(http_router).to have_received(:get).with('/tasks/:id')
        expect(show_route).to have_received(:to).with(Tasks::Show)

        expect(http_router).to have_received(:post).with('/tasks')
        expect(create_route).to have_received(:to).with(Tasks::Create)

        expect(http_router).to have_received(:put).with('/tasks/:id')
        expect(update_route).to have_received(:to).with(Tasks::Update)

        expect(http_router).to have_received(:delete).with('/tasks/:id')
        expect(delete_route).to have_received(:to).with(Tasks::Delete)
      end
    end

    context 'when there is a single resource in a namespace' do
      let(:routes) { Proc.new { namespace :magic do; add :markers; end } }

      it 'adds the resource within the namespace' do
        expect(http_router).to have_received(:get).with('/magic/:magic_id/markers')
        expect(index_route).to have_received(:to).with(Magic::Markers::Index)

        expect(http_router).to have_received(:get).with('/magic/:magic_id/markers/:id')
        expect(show_route).to have_received(:to).with(Magic::Markers::Show)

        expect(http_router).to have_received(:post).with('/magic/:magic_id/markers')
        expect(create_route).to have_received(:to).with(Magic::Markers::Create)

        expect(http_router).to have_received(:put).with('/magic/:magic_id/markers/:id')
        expect(update_route).to have_received(:to).with(Magic::Markers::Update)

        expect(http_router).to have_received(:delete).with('/magic/:magic_id/markers/:id')
        expect(delete_route).to have_received(:to).with(Magic::Markers::Delete)
      end
    end

    context 'when there is a single resource in a nested namespace' do
      let(:routes) { Proc.new { namespace :posts do; namespace :authors do; add :avatars; end; end } }

      it 'adds the resource within the namespace' do
        expect(http_router).to have_received(:get).with('/posts/:posts_id/authors/:authors_id/avatars')
        expect(index_route).to have_received(:to).with(Posts::Authors::Avatars::Index)

        expect(http_router).to have_received(:get).with('/posts/:posts_id/authors/:authors_id/avatars/:id')
        expect(show_route).to have_received(:to).with(Posts::Authors::Avatars::Show)

        expect(http_router).to have_received(:post).with('/posts/:posts_id/authors/:authors_id/avatars')
        expect(create_route).to have_received(:to).with(Posts::Authors::Avatars::Create)

        expect(http_router).to have_received(:put).with('/posts/:posts_id/authors/:authors_id/avatars/:id')
        expect(update_route).to have_received(:to).with(Posts::Authors::Avatars::Update)

        expect(http_router).to have_received(:delete).with('/posts/:posts_id/authors/:authors_id/avatars/:id')
        expect(delete_route).to have_received(:to).with(Posts::Authors::Avatars::Delete)
      end
    end
  end
end