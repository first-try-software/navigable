require_relative '../../lib/navigable/routable'

class Command
  extend Navigable::Routable

  def execute; end
end

class NoParamsCommand < Command; end

class RouterParamsCommand < Command
  def initialize(id:); end
end

class RackRequestParamsCommand < Command
  def initialize(search:); end
end

class ParsedBodyParamsCommand < Command
  def initialize(title:, description:); end
end

class PerformCommand < Command
  responds_with_method :perform

  def perform; end
end

RSpec.describe Navigable::Routable do
  describe '.call' do
    let(:env) { { 'router.request' => router_request, 'router.params' => router_params, 'parsed_body' => parsed_body } }

    let(:router_request) { instance_double(HttpRouter::Request, rack_request: rack_request) }
    let(:rack_request) { instance_double(Rack::Request, params: rack_request_params) }
    let(:rack_request_params) { {} }
    let(:router_params) { {} }
    let(:parsed_body) { {} }

    context 'when there are no params' do
      context 'when a responds_with_method has NOT been configured' do
        subject(:call) { NoParamsCommand.call(env) }

        let(:no_params_command) { instance_double(NoParamsCommand, execute: true) }

        before do
          allow(NoParamsCommand).to receive(:new).and_return(no_params_command)

          call
        end

        it 'instantiates a command' do
          expect(NoParamsCommand).to have_received(:new).with(no_args)
        end

        it 'calls execute on the command' do
          expect(no_params_command).to have_received(:execute).with(no_args)
        end
      end

      context 'when a responds_with_method has been configured' do
        subject(:call) { PerformCommand.call(env) }

        let(:perform_command) { instance_double(PerformCommand, perform: true) }

        before do
          allow(PerformCommand).to receive(:new).and_return(perform_command)

          call
        end

        it 'calls the configured method on the command' do
          expect(perform_command).to have_received(:perform).with(no_args)
        end
      end
    end

    context 'when there are rack request params (query string and form data)' do
      subject(:call) { RackRequestParamsCommand.call(env) }

      let(:rack_request_params) { { search: 'toast' } }

      before do
        allow(RackRequestParamsCommand).to receive(:new).and_call_original

        call
      end

      it 'instantiates a command' do
        expect(RackRequestParamsCommand).to have_received(:new).with(search: 'toast')
      end
    end

    context 'when there are router params' do
      subject(:call) { RouterParamsCommand.call(env) }

      let(:router_params) { { id: '123' } }

      before do
        allow(RouterParamsCommand).to receive(:new).and_call_original

        call
      end

      it 'instantiates a command' do
        expect(RouterParamsCommand).to have_received(:new).with(id: '123')
      end
    end

    context 'when there are parsed body params' do
      subject(:call) { ParsedBodyParamsCommand.call(env) }

      let(:parsed_body) { { 'title' => 'title', 'description' => 'description' } }

      before do
        allow(ParsedBodyParamsCommand).to receive(:new).and_call_original

        call
      end

      it 'instantiates a command' do
        expect(ParsedBodyParamsCommand).to have_received(:new).with(title: 'title', description: 'description')
      end
    end
  end
end