RSpec.describe Navigable::Entity do
  subject(:entity) { entity_klass.new(params) }

  let(:entity_klass) do
    Class.new do
      extend Navigable::Entity
      attr_accessor :id, :title, :created_at, :updated_at

      def initialize(params)
        @id = params[:id]
        @title = params[:title]
        @created_at = params[:created_at]
        @updated_at = params[:updated_at]
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

  describe '#valid?' do
    subject(:valid?) { entity.valid? }

    it { should be true }
  end

  describe '#merge' do
    subject(:merge) { entity.merge(attributes) }

    let(:attributes) { { title: 'new title' } }

    it 'merges the attributes with the entity attributes' do
      expect(merge).to have_attributes(params.merge(attributes))
    end
  end

  describe '#to_json' do
    subject(:to_json) { entity.to_json }

    it 'returns a json representation of the entity' do
      expect(to_json).to eq(params.to_json)
    end
  end
end
