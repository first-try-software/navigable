RSpec.describe Navigable::CLI do
  subject(:cli) { described_class.new }

  let(:command_args) { [] }
  let(:generator_arg) { no_args }

  shared_examples 'a cli command' do |generator_class|

    before do
      allow(generator_class).to receive(:start)

      cli.public_send(command, *command_args)
    end

    it "delegates to #{generator_class}" do
      expect(generator_class).to have_received(:start).with(generator_arg)
    end
  end

  describe '#new' do
    let(:command) { :new }
    let(:command_args) { ['Gilligan'] }
    let(:generator_arg) { ['gilligan'] }

    it_behaves_like 'a cli command', Navigable::Generators::New
  end

  describe '#server' do
    let(:command) { :server }

    it_behaves_like 'a cli command', Navigable::Generators::Server
  end

  describe '#start' do
    let(:command) { :start }

    it_behaves_like 'a cli command', Navigable::Generators::Start
  end

  describe '#stop' do
    let(:command) { :stop }

    it_behaves_like 'a cli command', Navigable::Generators::Stop
  end

  describe '#open' do
    let(:command) { :open }

    it_behaves_like 'a cli command', Navigable::Generators::Open
  end

  describe '#generate' do
    let(:command) { :generate }
    let(:command_args) { ['resource', 'posts'] }
    let(:generator_arg) { ['posts'] }

    it_behaves_like 'a cli command', Navigable::Generators::Resource
  end
end