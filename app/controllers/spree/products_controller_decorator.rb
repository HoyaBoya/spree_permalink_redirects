module Spree
  ProductsController.class_eval do
    # Replace the existing load_product with a new one.
    # https://github.com/spree/spree/blob/master/frontend/app/controllers/spree/products_controller.rb#L40
    alias_method :original_load_product, :load_product

    # Call existing logic, but handle RecordNotFound and attempt to find permalink history for associated product.
    def load_product
      begin 
        original_load_product
      rescue ActiveRecord::RecordNotFound => e
        # No product, check for a redirect
        permalink_redirect = Spree::PermalinkRedirect.where(permalink: params[:id], model_type: Spree::Product.name).last

        if permalink_redirect.nil?
          # Redirect not found, re-raise the exception
          raise e
        else
          # Redirect found, 302
          redirect_to product_url(permalink_redirect.model), status: 302
        end
      end
    end
  end
end
