require 'spec_helper'

describe Spree::Api::ProductsController do
  render_views

  before(:each) do
    @routes = Spree::Core::Engine.routes
    stub_authentication!
  end

  describe 'redirect' do
    subject { get :show, id: 'foo', format: 'json' }

    context 'when product exists' do
      before do
        create(:product, permalink: 'foo')
      end

      it 'should be ok' do
        subject
        expect(response).to be_ok
      end

      it 'should be JSON' do
        subject
        expect(JSON.parse(response.body)).to be_a(Hash)
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
        expect(response['Location']).to eq(@routes.url_helpers.api_product_url(product, host: 'test.host'))
      end
    end

    context 'when neither product nor permalink exist' do
      it 'should be 404' do
        subject
        expect(response.code.to_i).to eq(404)
      end
    end
  end

  private

  def stub_authentication!
    user = create(:user)
    warden = double(:warden, user: user, authenticate: user)
    controller.stub(:env).and_return({'warden' => warden})
    controller.request.env['warden'] = warden
  end
end
