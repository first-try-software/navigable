require_relative '../../lib/navigable/response'

RSpec.describe Navigable::Response do
  describe '#to_rack_response' do
    subject(:to_rack_response) { described_class.new(params).to_rack_response }

    let(:params) { {} }

    context 'when params does NOT include a status' do
      it 'returns status 200' do
        expect(to_rack_response).to match_array([200, anything, anything])
      end
    end

    context 'when params includes a status' do
      let(:params) { { status: status } }
      let(:status) { 418 }

      it 'returns the provided status' do
        expect(to_rack_response).to match_array([status, anything, anything])
      end
    end

    context 'when params does NOT include headers' do
      context 'and the content type is JSON' do
        let(:params) { { json: {} } }

        it 'adds an application/json content type to headers' do
          expect(to_rack_response).to match_array([
            anything,
            a_hash_including('Content-Type' => 'application/json'),
            anything
          ])
        end
      end

      context 'and the content type is HTML' do
        let(:params) { { html: '<html></html>' } }

        it 'adds an text/html content type to headers' do
          expect(to_rack_response).to match_array([
            anything,
            a_hash_including('Content-Type' => 'text/html'),
            anything
          ])
        end
      end

      context 'and the content type is TEXT' do
        let(:params) { { text: 'UN TEXTO' } }

        it 'adds an text/plain content type to headers' do
          expect(to_rack_response).to match_array([
            anything,
            a_hash_including('Content-Type' => 'text/plain'),
            anything
          ])
        end
      end

      context 'and the content type is NOT specified' do
        let(:params) { { body: '0x0123' } }

        it 'does not add a content type header' do
          expect(to_rack_response).to match_array([anything, {}, anything])
        end
      end
    end

    context 'when params include headers' do
      let(:params) { { headers: headers } }
      let(:headers) { { 'X-Test-Header' => 'Look Ma! I did a header!' } }

      it 'returns the provided headers' do
        expect(to_rack_response).to match_array([
          anything,
          a_hash_including(headers),
          anything
        ])
      end

      context 'and the headers do NOT include content type' do
        let(:params) { { headers: headers, text: '' } }

        it 'adds a content type header' do
          expect(to_rack_response).to match_array([
            anything,
            a_kind_of(Hash).and(have_key('Content-Type')),
            anything
          ])
        end
      end

      context 'and the headers include content type' do
        let(:headers) { { 'Content-Type' => 'image/png' } }

        context 'and the content is JSON, HTML or text' do
          let(:params) { { headers: headers, text: '' } }

          it 'overrides the provided content type' do
            expect(to_rack_response).to match_array([
              anything,
              a_hash_including('Content-Type' => 'text/plain'),
              anything
            ])
          end
        end

        context 'and the content is NOT JSON, HTML or text' do
          let(:params) { { headers: headers, body: '' } }

          it 'does NOT alter the content type' do
            expect(to_rack_response).to match_array([
              anything,
              a_hash_including('Content-Type' => 'image/png'),
              anything
            ])
          end
        end
      end
    end

    context 'when there is NOT content' do
      it 'contains an empty string in the body' do
        expect(to_rack_response).to match_array([
          anything,
          anything,
          ['']
        ])
      end
    end

    context 'when there is content' do
      context 'and the content only includes JSON' do
        let(:params) { { json: json } }

        context 'and the JSON contains a valid JSON string' do
          let(:json) { { key: 'value' }.to_json }

          it 'returns the valid JSON string' do
            expect(to_rack_response).to match_array([
              anything,
              anything,
              [json]
            ])
          end
        end

        context 'and the JSON is NOT a valid JSON string' do
          let(:json) { { key: 'value' } }

          it 'returns a valid JSON string' do
            expect(to_rack_response).to match_array([
              anything,
              anything,
              [json.to_json]
            ])
          end
        end
      end

      context 'and the content only includes HTML' do
        let(:params) { { html: html } }
        let(:html) { '<html></html>' }

        it 'returns the HTML' do
          expect(to_rack_response).to match_array([
            anything,
            anything,
            [html]
          ])
        end
      end

      context 'and the content only includes text' do
        let(:params) { { text: text } }
        let(:text) { 'text' }

        it 'returns the text' do
          expect(to_rack_response).to match_array([
            anything,
            anything,
            [text]
          ])
        end
      end

      context 'and the content only includes a body' do
        let(:params) { { body: body } }
        let(:body) { 'body' }

        it 'returns the content' do
          expect(to_rack_response).to match_array([
            anything,
            anything,
            [body]
          ])
        end
      end

      context 'and the content includes JSON and HTML' do
        let(:params) { { json: json, html: html } }
        let(:json) { { key: 'value' }.to_json }
        let(:html) { '<html></html>' }

        it 'returns the JSON' do
          expect(to_rack_response).to match_array([
            anything,
            anything,
            [json]
          ])
        end
      end

      context 'and the content includes HTML and text' do
        let(:params) { { html: html, text: text } }
        let(:html) { '<html></html>' }
        let(:text) { 'text' }

        it 'returns the HTML' do
          expect(to_rack_response).to match_array([
            anything,
            anything,
            [html]
          ])
        end
      end

      context 'and the content includes text and body' do
        let(:params) { { text: text, body: body } }
        let(:text) { 'text' }
        let(:body) { 'body' }

        it 'returns the text' do
          expect(to_rack_response).to match_array([
            anything,
            anything,
            [text]
          ])
        end
      end
    end
  end
end