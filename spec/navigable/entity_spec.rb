require_relative '../../lib/navigable/entity'

RSpec.describe Navigable::Entity do
  subject(:entity) { entity_klass.new(params) }

  let(:entity_klass) do
    Class.new(Navigable::Entity) do
      attr_accessor :title

      def initialize(params)
        @title = params[:title]
        super
      end
    end
  end

  let(:params) do
    {
      id: id,
      title: title,
      created_at: created_at,
      updated_at: updated_at
    }
  end

  let(:id) { 123 }
  let(:title) { 'title' }
  let(:created_at) { 'created_at' }
  let(:updated_at) { 'updated_at' }

  before do
    allow(entity_klass).to receive(:name).and_return('Post')
  end

  describe '#attributes' do
    subject(:attributes) { entity.attributes }

    context 'when params include only and all attributes' do
      let(:params) do
        {
          id: id,
          title: title,
          created_at: created_at,
          updated_at: updated_at
        }
      end

      it 'returns a hash with all of the attributes' do
        expect(attributes).to eq({
          id: id,
          title: title,
          created_at: created_at,
          updated_at: updated_at
        })
      end
    end

    context 'when params include extra attributes' do
      let(:params) do
        {
          id: id,
          title: title,
          description: description,
          created_at: created_at,
          updated_at: updated_at
        }
      end

      let(:description) { 'description' }

      it 'ignores the extra attributes' do
        expect(attributes).to eq({
          id: id,
          title: title,
          created_at: created_at,
          updated_at: updated_at
        })
      end
    end

    context 'when params does NOT include all attributes' do
      let(:params) do
        {
          id: id,
          title: title,
        }
      end

      it 'returns nil for undefinded attributes' do
        expect(attributes).to eq({
          id: id,
          title: title,
          created_at: nil,
          updated_at: nil
        })
      end
    end
  end

  describe '#to_s' do
    subject(:to_s) { entity.to_s }

    it 'returns Entity: {attributes}' do
      expect(to_s)
        .to match('Post: {')
        .and match(entity.attributes.to_s)
    end
  end
end
