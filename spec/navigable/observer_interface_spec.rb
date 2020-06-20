RSpec.describe Navigable::ObserverInterface do
  subject(:observer) { observer_klass.new }

  let(:observer_klass) { Class.new { include Navigable::ObserverInterface } }

  it_behaves_like 'an observer'
end
