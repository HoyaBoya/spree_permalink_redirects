require 'spec_helper'

describe Spree::ProductsController do
  before(:each) do
    @routes = Spree::Core::Engine.routes
    controller.stub spree_current_user: mock_model(Spree.user_class, has_spree_role?: true, last_incomplete_spree_order: nil, spree_api_key: 'fake')
  end

  describe 'check_redirect' do
    subject { get :show, id: 'foo' }

    context 'when product exists' do
      before do
        create(:product, permalink: 'foo')
      end

      it 'should be ok' do
        subject
        expect(response).to be_ok
      end
    end

    context 'when product does not exist but permalink exists' do
      let(:product) do
        create(:product, permalink: 'bar')
      end

      before do
        Spree::PermalinkRedirect.create!(permalink: 'foo', model_id: product.id, model_type: product.class.to_s)
      end

      it 'should redirect' do
        subject
        expect(response).to be_redirect
      end

      it 'should have location header' do
        subject
        expect(response['Location']).to eq(product_url(product))
      end
    end

    context 'when neither product nor permalink exist' do
      it 'should 404' do
        subject
        expect(response.code.to_i).to eq(404)
      end
    end
  end
end
