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

  describe '.register_action' do
    let(:registrar) { instance_double(Navigable::Registrar, register: true) }
    let(:app) { instance_double(Navigable::Application, router: router) }
    let(:router) { instance_double(Hanami::Router) }
    let(:child) { Class.new(action_klass) { register_action } }

    before do
      allow(Navigable::Registrar).to receive(:new).and_return(registrar)
      allow(Navigable).to receive(:app).and_return(app)
    end

    it 'registers the class with the Registrar' do
      expect(Navigable::Registrar).to have_received(:new).with(child, router)
      expect(registrar).to have_received(:register)
    end
  end

  describe '.call' do
    subject(:call) { action_klass.call(env) }

    let(:env) do
      {
        'parsed_body' => parsed_body,
        'router.params' => url_params
      }
    end

    let(:rack_request) do
      instance_double(Rack::Request, params: form_params, accept_media_types: accept_media_types)
    end

    let(:accept_media_types) { [] }
    let(:form_params) { {} }
    let(:parsed_body) { {} }
    let(:url_params) { {} }

    before do
      allow(Rack::Request).to receive(:new).and_return(rack_request)
      allow(action_klass).to receive(:new).and_call_original
    end

    context 'when there are no params' do
      context 'when a responds_with_method has NOT been configured' do
        context 'and there is an execute method' do
          let(:no_params_action) do
            instance_double(action_klass, execute: Navigable::Response.new({}))
          end

          before do
            allow(action_klass).to receive(:new).and_return(no_params_action)

            call
          end

          it 'instantiates an action' do
            expect(action_klass).to have_received(:new).with(
              request_params: {},
              request_headers: a_kind_of(Hash)
            )
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
      let(:form_params) { { search: 'toast' } }
      let(:parsed_body) { { 'title' => 'title', 'description' => 'description' } }
      let(:url_params) { { id: '123' } }

      it 'instantiates an action' do
        call

        expect(action_klass).to have_received(:new).with(
          request_params: {
            search: 'toast',
            title: 'title',
            description: 'description',
            id: '123'
          },
          request_headers: a_kind_of(Hash)
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

    context 'when there are headers' do
      context 'and the accept_media_types are empty' do
        let(:accept_media_types) { [] }
        let(:preferred_media_type) { nil }

        it 'instantiates an action' do
          call

          expect(action_klass).to have_received(:new).with(
            request_params: a_kind_of(Hash),
            request_headers: {
              accept_media_types: accept_media_types,
              preferred_media_type: preferred_media_type
            }
          )
        end
      end

      context 'and the accept_media_types are NOT empty' do
        let(:accept_media_types) { ['application/json', 'text/html'] }
        let(:preferred_media_type) { 'application/json' }

        it 'instantiates an action' do
          call

          expect(action_klass).to have_received(:new).with(
            request_params: a_kind_of(Hash),
            request_headers: {
              accept_media_types: accept_media_types,
              preferred_media_type: preferred_media_type
            }
          )
        end
      end
    end
  end
end
