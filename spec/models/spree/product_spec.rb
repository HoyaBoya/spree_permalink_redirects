require 'spec_helper'

describe Spree::Product do
  describe '#handle_permalink_changed' do
    let(:product) do
      create(:product, permalink: 'foo')
    end

    subject do
      product.permalink = 'bar'
      product.save
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

      it 'should have Spree::Product as model' do
        subject
        expect(Spree::PermalinkRedirect.first.model.id).to eq(product.id)
      end
    end

    context 'when permalink changes and redirect exists' do
      before do
        Spree::PermalinkRedirect.create(permalink: 'foo', model_id: product.id, model_type: product.class.to_s)
        expect(Spree::PermalinkRedirect.count).to eq(1)
      end

      it 'should have one Spree::PermalinkRedirect' do
        subject
        expect(Spree::PermalinkRedirect.count).to eq(1)
      end
    end
  end
end
