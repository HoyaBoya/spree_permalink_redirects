require 'spec_helper'

describe Spree::PermalinkRedirect do
  describe '#model' do
    context 'when model_type is Spree::Product' do
      let(:permalink_redirect) do 
        redirect = Spree::PermalinkRedirect.new(
          model_type: Spree::Product.to_s,
          model_id:   create(:product, permalink: '/new/link').id,
          permalink:  '/old/link'
        )
      end

      before do
        permalink_redirect.save
      end

      subject { Spree::PermalinkRedirect.first.model }

      it 'should return Spree::Product' do
        expect(subject).to be_a(Spree::Product)
      end
      
      it "should have permalink '/new/link'" do
        expect(subject.permalink).to eq('/new/link')
      end
    end
  end
end
