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

    context 'when permalink changes reverts' do
      it 'should not create duplicates' do
        10.times do
          product.permalink = 'bar'
          product.save
          product.permalink = 'foo'
          product.save
        end 

        expect(Spree::PermalinkRedirect.count).to eq(2)
      end 
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
        expect(Spree::PermalinkRedirect.first.model).to be_a(Spree::Product)
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
