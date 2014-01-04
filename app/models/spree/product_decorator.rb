module Spree
  Product.class_eval do
    include Spree::PermalinkHelper

    after_save :handle_permalink_changed, :if => :permalink_changed?
  end
end
