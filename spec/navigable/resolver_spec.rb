RSpec.describe Navigable::Resolver do
  let(:resolver_klass) { Class.new { extend Navigable::Resolver } }

  describe '.default_resolver' do
    subject(:default_resolver) { resolver_klass.default_resolver }

    before do
      allow(resolver_klass).to receive(:default_manufacturable)

      default_resolver
    end

    it 'delegates management of the default resolver to Manufacturable' do
      expect(resolver_klass).to have_received(:default_manufacturable)
    end
  end

  describe '.resolves' do
    subject(:resolves) { resolver_klass.resolves(resolver_key) }

    let(:resolver_key) { :resolver_key }

    before do
      allow(resolver_klass).to receive(:corresponds_to)

      resolves
    end

    it 'delegates management of resolvers to Manufacturable' do
      expect(resolver_klass).to have_received(:corresponds_to).with(resolver_key, Navigable::Resolver::TYPE)
    end
  end

  describe '.extended' do
    subject(:extended_object) { resolver_klass.new }

    let(:observer) { extended_object }

    it_behaves_like 'an observer'

    it 'defines an resolve method that raises an error' do
      expect { extended_object.resolve }.to raise_error(NotImplementedError)
    end
  end
end
