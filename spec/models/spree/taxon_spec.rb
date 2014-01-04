require 'spec_helper'

describe Spree::Taxon do
  describe '#handle_permalink_changed' do
    let(:taxon) do
      Spree::Taxon.create!(name: 'foo', permalink: 'foo')
    end

    subject do
      taxon.permalink = 'bar'
      taxon.save
    end

    context 'when permalink changes' do
      it 'should create one Spree::PermalinkRedirect' do
        subject
        expect(Spree::PermalinkRedirect.count).to eq(1)
      end

      it 'should have foo as permalink' do
        subject
        expect(Spree::PermalinkRedirect.first.permalink).to eq('foo')
      end

      it 'should have Spree::Taxon as model' do
        subject
        expect(Spree::PermalinkRedirect.first.model.id).to eq(taxon.id)
        expect(Spree::PermalinkRedirect.first.model).to be_a(Spree::Taxon)
      end
    end

    context 'when permalink changes and redirect exists' do
      before do
        Spree::PermalinkRedirect.create(permalink: 'foo', model_id: taxon.id, model_type: taxon.class.to_s)
        expect(Spree::PermalinkRedirect.count).to eq(1)
      end

      it 'should have one Spree::PermalinkRedirect' do
        subject
        expect(Spree::PermalinkRedirect.count).to eq(1)
      end
    end
  end
end
