require_relative '../../lib/navigable/command'
require_relative '../../lib/navigable/response'

class Command
  extend Navigable::Command

  def initialize(params); end
  def execute; render; end
end

class PerformCommand
  extend Navigable::Command

  responds_with_method :perform

  def perform; render; end
end

class NoExecuteCommand
  extend Navigable::Command

  def initialize(params); end
end

RSpec.describe Navigable::Command do
  describe '.inherited' do
    let(:registrar) { instance_double(Navigable::Registrar, register: true) }

    before do
      allow(Navigable::Registrar).to receive(:new).and_return(registrar)
    end

    context 'when inheritance happens naturally' do
      let(:child) { Class.new(PerformCommand) }

      it 'passes the parent responds_with_method down to child' do
        expect(child.instance_variable_get(:@responds_with_method)).to be(:perform)
      end
    end

    context 'when inheritance is forced at the barrel of a gun' do
      let(:app) { instance_double(Navigable::Application, router: router) }
      let(:router) { instance_double(Hanami::Router) }
      let(:child) { Class.new(Command) }

      before do
        allow(Navigable).to receive(:app).and_return(app)
      end

      it 'registers the child class with the Registrar' do
        expect(Navigable::Registrar).to have_received(:new).with(child, router)
        expect(registrar).to have_received(:register)
      end
    end
  end

  describe '.call' do
    let(:env) do
      {
        'parsed_body' => parsed_body,
        'router.params' => router_params
      }
    end

    let(:rack_request) do
      instance_double(Rack::Request, params: query_string_and_form_data_params)
    end

    let(:query_string_and_form_data_params) { {} }
    let(:parsed_body) { {} }
    let(:router_params) { {} }

    before do
      allow(Rack::Request).to receive(:new).and_return(rack_request)
    end

    context 'when there are no params' do
      context 'when a responds_with_method has NOT been configured' do
        context 'and there is an execute method' do
          subject(:call) { Command.call(env) }

          let(:no_params_command) do
            instance_double(Command, execute: Navigable::Response.new({}))
          end

          before do
            allow(Command).to receive(:new).and_return(no_params_command)

            call
          end

          it 'instantiates a command' do
            expect(Command).to have_received(:new).with({})
          end

          it 'calls execute on the command' do
            expect(no_params_command).to have_received(:execute).with(no_args)
          end
        end

        context 'and there is NOT an execute method' do
          subject(:call) { NoExecuteCommand.call(env) }

          it 'raises not implemented' do
            expect { call }.to raise_error(NotImplementedError)
          end
        end
      end

      context 'when a responds_with_method has been configured' do
        subject(:call) { PerformCommand.call(env) }

        let(:perform_command) do
          instance_double(PerformCommand, perform: Navigable::Response.new({}))
        end

        before do
          allow(PerformCommand).to receive(:new).and_return(perform_command)

          call
        end

        it 'calls the configured method on the command' do
          expect(perform_command).to have_received(:perform).with(no_args)
        end
      end
    end

    context 'when there are params' do
      subject(:call) { Command.call(env) }

      let(:query_string_and_form_data_params) { { search: 'toast' } }
      let(:parsed_body) { { 'title' => 'title', 'description' => 'description' } }
      let(:router_params) { { id: '123' } }

      before do
        allow(Command).to receive(:new).and_call_original

        call
      end

      it 'instantiates a command' do
        expect(Command).to have_received(:new).with(
          search: 'toast',
          title: 'title',
          description: 'description',
          id: '123'
        )
      end
    end
  end
end