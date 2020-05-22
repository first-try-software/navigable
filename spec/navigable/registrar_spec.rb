module Posts
  module Comments
    class Root; end
    class Index; end
    class Show; end
    class Create; end
    class Update; end
    class Delete; end
  end
end

RSpec.shared_examples 'a registered route' do
  subject(:registrar) { described_class.new(command, router) }

  describe '#register' do
    subject(:register) { registrar.register }

    let(:router) { instance_double(Hanami::Router) }

    before do
      allow(registrar).to receive(:puts)
      allow(router).to receive(verb)

      register
    end

    it 'prints the route' do
      expect(registrar).to have_received(:puts).with(printed_route)
    end

    it 'registers the route with the router' do
      expect(router).to have_received(verb).with(path, to: command)
    end
  end
end

RSpec.describe Navigable::Registrar do

  context 'when the route is root' do
    let(:command) { Posts::Comments::Root }
    let(:printed_route) { "   GET /                                                   =>  #{command}"}
    let(:verb) { :get }
    let(:path) { '/'}

    it_behaves_like 'a registered route'
  end

  context 'when the route is index' do
    let(:command) { Posts::Comments::Index }
    let(:printed_route) { "   GET /posts/:posts_id/comments                           =>  #{command}"}
    let(:verb) { :get }
    let(:path) { '/posts/:posts_id/comments'}

    it_behaves_like 'a registered route'
  end

  context 'when the route is show' do
    let(:command) { Posts::Comments::Show }
    let(:printed_route) { "   GET /posts/:posts_id/comments/:id                       =>  #{command}"}
    let(:verb) { :get }
    let(:path) { '/posts/:posts_id/comments/:id'}

    it_behaves_like 'a registered route'
  end

  context 'when the route is create' do
    let(:command) { Posts::Comments::Create }
    let(:printed_route) { "  POST /posts/:posts_id/comments                           =>  #{command}"}
    let(:verb) { :post }
    let(:path) { '/posts/:posts_id/comments'}

    it_behaves_like 'a registered route'
  end

  context 'when the route is update' do
    let(:command) { Posts::Comments::Update }
    let(:printed_route) { "   PUT /posts/:posts_id/comments/:id                       =>  #{command}"}
    let(:verb) { :put }
    let(:path) { '/posts/:posts_id/comments/:id'}

    it_behaves_like 'a registered route'
  end

  context 'when the route is delete' do
    let(:command) { Posts::Comments::Delete }
    let(:printed_route) { "DELETE /posts/:posts_id/comments/:id                       =>  #{command}"}
    let(:verb) { :delete }
    let(:path) { '/posts/:posts_id/comments/:id'}

    it_behaves_like 'a registered route'
  end
end
