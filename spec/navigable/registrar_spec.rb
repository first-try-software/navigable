class Root; end

module Posts
  module Comments
    class Index; end
    class Show; end
    class Create; end
    class Update; end
    class Delete; end
  end
end

RSpec.shared_examples 'a registered route' do
  before do
    allow(registrar).to receive(:puts)
    allow(router).to receive(verb)

    register
  end

  it 'registers the route with the router' do
    expect(router).to have_received(verb).with(path, to: action_klass)
  end
end

RSpec.describe Navigable::Registrar do
  subject(:registrar) { described_class.new(action_klass, router) }

  let(:router) { instance_double(Hanami::Router) }

  describe '#register' do
    subject(:register) { registrar.register }

    context 'when the route is not restful' do
      let(:action_klass) { class NotResful; end; NotResful }

      it 'raises InvalidRoute' do
        expect { register }.to raise_error(Navigable::InvalidRoute)
      end
    end

    context 'when the route is root' do
      let(:action_klass) { Root }
      let(:verb) { :get }
      let(:path) { '/'}

      it_behaves_like 'a registered route'

      context 'and the route has a namespace' do
        let(:action_klass) { module Namespace; class Root; end; end; Namespace::Root }

        it 'raises InvalidRoute' do
          expect { register }.to raise_error(Navigable::InvalidRoute)
        end
      end
    end

    context 'when the route is index' do
      let(:action_klass) { Posts::Comments::Index }
      let(:verb) { :get }
      let(:path) { '/posts/:posts_id/comments'}

      it_behaves_like 'a registered route'
    end

    context 'when the route is show' do
      let(:action_klass) { Posts::Comments::Show }
      let(:verb) { :get }
      let(:path) { '/posts/:posts_id/comments/:id'}

      it_behaves_like 'a registered route'
    end

    context 'when the route is create' do
      let(:action_klass) { Posts::Comments::Create }
      let(:verb) { :post }
      let(:path) { '/posts/:posts_id/comments'}

      it_behaves_like 'a registered route'
    end

    context 'when the route is update' do
      let(:action_klass) { Posts::Comments::Update }
      let(:verb) { :put }
      let(:path) { '/posts/:posts_id/comments/:id'}

      it_behaves_like 'a registered route'
    end

    context 'when the route is delete' do
      let(:action_klass) { Posts::Comments::Delete }
      let(:printed_route) { "DELETE /posts/:posts_id/comments/:id                       =>  #{action_klass}"}
      let(:verb) { :delete }
      let(:path) { '/posts/:posts_id/comments/:id'}

      it_behaves_like 'a registered route'
    end
  end
end