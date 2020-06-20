RSpec.describe Navigable::Command do
  let(:command_klass) { Class.new { extend Navigable::Command } }

  describe '.extended' do
    subject(:extended_object) { command_klass.new(params: {}) }

    it 'defines a constructor that accepts params' do
      expect { extended_object }.not_to raise_error
    end

    it 'defines an execute method that raises an error' do
      expect { extended_object.execute }.to raise_error(NotImplementedError)
    end

    it 'defines a corresponds_to method that delegates to Manufacturable::Item with a the Navigable Command type' do
      expect { command_klass.corresponds_to(:key) }
        .to change { Manufacturable.registered_types }
        .from([])
        .to([Navigable::Command::TYPE])
    end
  end
end
