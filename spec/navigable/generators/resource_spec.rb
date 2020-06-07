RSpec.describe Navigable::Generators::Resource do
  subject(:generator) { described_class.new(args) }

  let(:args) { [resource_name] }
  let(:resource_name) { 'resource_name' }
  let(:plural_resource_name) { 'resource_names' }

  before do
    allow(generator).to receive(:puts)
    allow(generator).to receive(:template)
    allow(generator).to receive(:run)
  end

  describe '.source_root' do
    subject(:source_root) { described_class.source_root }

    it 'returns the assets directory' do
      expect(source_root).to match('../../assets/templates')
    end
  end

  describe '.destination_root' do
    subject(:destination_root) { described_class.destination_root }

    before do
      allow(Dir).to receive(:pwd)

      destination_root
    end

    it 'returns the current directory' do
      expect(Dir).to have_received(:pwd).with(no_args)
    end
  end

  describe '#create' do
    subject(:create) { generator.create }

    let(:actions) { ['index', 'show', 'create', 'update', 'delete'] }

    before { create }

    it 'prints a message' do
      expect(generator).to have_received(:puts).with(a_kind_of(String))
    end

    it 'creates command classes and specs' do
      actions.each do |action|
        expect(generator).to have_received(:template).with("#{action}.rb.erb", "domain/#{plural_resource_name}/#{action}.rb")
        expect(generator).to have_received(:template).with("#{action}_spec.rb.erb", "spec/domain/#{plural_resource_name}/#{action}_spec.rb")
      end
    end

    it 'creates repository class and spec' do
      expect(generator).to have_received(:template).with('repository.rb.erb', "domain/#{plural_resource_name}/repository.rb")
      expect(generator).to have_received(:template).with('repository_spec.rb.erb', "spec/domain/#{plural_resource_name}/repository_spec.rb")
    end
  end

  describe '#run_specs' do
    subject(:run_specs) { generator.run_specs }

    before { run_specs }

    it 'prints a message' do
      expect(generator).to have_received(:puts).with(a_kind_of(String))
    end

    it 'runs bundle exec rspec --init inside the app directory' do
      expect(generator).to have_received(:run).with('bundle exec rspec')
    end
  end
end