require_relative '../../lib/navigable/action'
require_relative '../../lib/navigable/response'
require_relative '../../lib/navigable/listener'

RSpec.describe Navigable::Action do
  let(:action_klass) do
    Class.new do
      extend Navigable::Action
      def execute; render; end
    end
  end

  let(:no_execute_action_klass) do
    Class.new do
      extend Navigable::Action
    end
  end

  describe '.extended' do
    subject(:extended_object) { no_execute_action_klass.new({}) }

    it 'defines a constructor that accepts params' do
      expect { extended_object }.not_to raise_error
    end

    it 'defines an execute method that raise an error' do
      expect { extended_object.execute }.to raise_error(NotImplementedError)
    end
  end

  describe '.inherited' do
    let(:registrar) { instance_double(Navigable::Registrar, register: true) }
    let(:app) { instance_double(Navigable::Application, router: router) }
    let(:router) { instance_double(Hanami::Router) }
    let(:child) { Class.new(action_klass) }

    before do
      allow(Navigable::Registrar).to receive(:new).and_return(registrar)
      allow(Navigable).to receive(:app).and_return(app)
    end

    it 'registers the child class with the Registrar' do
      expect(Navigable::Registrar).to have_received(:new).with(child, router)
      expect(registrar).to have_received(:register)
    end
  end

  describe '.add_default_listener' do
    let(:default_listener_klass) do
      Class.new(Navigable::Listener) do
        listen_to_all_actions
      end
    end

    it 'adds a listener to the default listeners array on the module itself' do
      expect(Navigable::Action.default_listener_klasses).to include(default_listener_klass)
    end
  end

  describe '.listen_to' do
    let(:listener_klass) { Class.new(Navigable::Listener) }

    before do
      listener_klass.listen_to(action_klass)
    end

    it 'adds a listener to the listeners array on the class instance' do
      expect(action_klass.listeners).to include(listener_klass)
    end
  end

  describe '.call' do
    let(:env) do
      {
        'parsed_body' => parsed_body,
        'router.params' => url_params
      }
    end

    let(:rack_request) do
      instance_double(Rack::Request, params: form_params)
    end

    let(:form_params) { {} }
    let(:parsed_body) { {} }
    let(:url_params) { {} }

    before do
      allow(Rack::Request).to receive(:new).and_return(rack_request)
    end

    context 'when there are no params' do
      context 'when a responds_with_method has NOT been configured' do
        context 'and there is an execute method' do
          subject(:call) { action_klass.call(env) }

          let(:no_params_action) do
            instance_double(action_klass, execute: Navigable::Response.new({}))
          end

          before do
            allow(action_klass).to receive(:new).and_return(no_params_action)

            call
          end

          it 'instantiates a action' do
            expect(action_klass).to have_received(:new).with({})
          end

          it 'calls execute on the action' do
            expect(no_params_action).to have_received(:execute).with(no_args)
          end
        end

        context 'and there is NOT an execute method' do
          subject(:call) { no_execute_action_klass.call(env) }

          it 'raises not implemented' do
            expect { call }.to raise_error(NotImplementedError)
          end
        end
      end
    end

    context 'when there are params' do
      subject(:call) { action_klass.call(env) }

      let(:form_params) { { search: 'toast' } }
      let(:parsed_body) { { 'title' => 'title', 'description' => 'description' } }
      let(:url_params) { { id: '123' } }

      before do
        allow(action_klass).to receive(:new).and_call_original
      end

      it 'instantiates a action' do
        call

        expect(action_klass).to have_received(:new).with(
          search: 'toast',
          title: 'title',
          description: 'description',
          id: '123'
        )
      end

      context 'and the action executes successfully' do
        before do
          action_klass.class_eval do
            def execute; successfully({}); end
          end
        end

        it 'renders a successful response' do
          expect(call).to match_array([200, { 'Content-Type' => 'application/json' }, [a_kind_of(String)]])
        end
      end

      context 'and the action fails to validate' do
        before do
          action_klass.class_eval do
            def execute; failed_to_validate({}); end
          end
        end

        it 'renders a successful response' do
          expect(call).to match_array([400, { 'Content-Type' => 'application/json' }, [a_string_matching('"error":')]])
        end
      end

      context 'and the action fails to find' do
        before do
          action_klass.class_eval do
            def execute; failed_to_find({}); end
          end
        end

        it 'renders a successful response' do
          expect(call).to match_array([404, { 'Content-Type' => 'application/json' }, [a_string_matching('"error":')]])
        end
      end

      context 'and the action fails to create' do
        before do
          action_klass.class_eval do
            def execute; failed_to_create({}); end
          end
        end

        it 'renders a successful response' do
          expect(call).to match_array([500, { 'Content-Type' => 'application/json' }, [a_string_matching(/"error":.*creating/)]])
        end
      end

      context 'and the action fails to update' do
        before do
          action_klass.class_eval do
            def execute; failed_to_update({}); end
          end
        end

        it 'renders a successful response' do
          expect(call).to match_array([500, { 'Content-Type' => 'application/json' }, [a_string_matching(/"error":.*updating/)]])
        end
      end

      context 'and the action fails to delete' do
        before do
          action_klass.class_eval do
            def execute; failed_to_delete({}); end
          end
        end

        it 'renders a successful response' do
          expect(call).to match_array([500, { 'Content-Type' => 'application/json' }, [a_string_matching(/"error":.*deleting/)]])
        end
      end
    end
  end
end