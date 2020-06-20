RSpec.describe Navigable::Resolver do
  let(:resolver_klass) { Class.new { extend Navigable::Resolver } }

  describe '.extended' do
    subject(:extended_object) { resolver_klass.new }

    let(:observer) { extended_object }

    it_behaves_like 'an observer'

    it 'defines an resolve method that raises an error' do
      expect { extended_object.resolve }.to raise_error(NotImplementedError)
    end
  end
end
