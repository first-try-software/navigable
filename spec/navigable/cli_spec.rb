RSpec.describe Navigable::CLI do
  subject(:cli) { described_class.new }

  let(:action_args) { [] }
  let(:generator_arg) { no_args }

  shared_examples 'a cli action' do |generator_class|

    before do
      allow(generator_class).to receive(:start)

      cli.public_send(action, *action_args)
    end

    it "delegates to #{generator_class}" do
      expect(generator_class).to have_received(:start).with(generator_arg)
    end
  end

  describe '#new' do
    let(:action) { :new }
    let(:action_args) { ['Gilligan'] }
    let(:generator_arg) { ['gilligan'] }

    it_behaves_like 'a cli action', Navigable::Generators::New
  end

  describe '#server' do
    let(:action) { :server }

    it_behaves_like 'a cli action', Navigable::Generators::Server
  end

  describe '#start' do
    let(:action) { :start }

    it_behaves_like 'a cli action', Navigable::Generators::Start
  end

  describe '#stop' do
    let(:action) { :stop }

    it_behaves_like 'a cli action', Navigable::Generators::Stop
  end

  describe '#open' do
    let(:action) { :open }

    it_behaves_like 'a cli action', Navigable::Generators::Open
  end

  describe '#generate' do
    let(:action) { :generate }
    let(:action_args) { ['resource', 'posts'] }
    let(:generator_arg) { ['posts'] }

    it_behaves_like 'a cli action', Navigable::Generators::Resource
  end
end