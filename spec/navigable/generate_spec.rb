RSpec.describe Navigable::Generate do
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

  describe '#resource' do
    let(:command) { :resource }
    let(:command_args) { ['posts'] }
    let(:generator_arg) { ['posts'] }

    it_behaves_like 'a cli command', Navigable::Generators::Resource
  end
end