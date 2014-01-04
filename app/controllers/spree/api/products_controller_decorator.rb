module Spree
  module Api
    ProductsController.class_eval do
      alias_method :original_show, :show

      def show
        begin
          original_show
        rescue ActiveRecord::RecordNotFound => e
          # No product, check for a redirect
          permalink_redirect = Spree::PermalinkRedirect.where(permalink: params[:id], model_type: Spree::Product.name).last

          if permalink_redirect.nil?
            # Redirect not found, re-raise the exception
            raise e
          else
            # Redirect found, 302
            response.headers['Location'] = Spree::Core::Engine.routes.url_helpers.api_product_url(permalink_redirect.model, host: request.host)
            render text: '', status: 302 and return
          end
        end
      end
    end
  end
end
