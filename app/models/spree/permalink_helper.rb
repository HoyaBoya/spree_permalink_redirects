module Spree
  module PermalinkHelper
    def handle_permalink_changed
      # Do not allow nil to be saved
      return if permalink_was.nil?

      # See if we already have a link for this.
      permalink_redirect = Spree::PermalinkRedirect.where(
        permalink:  permalink_was,
        model_id:   id,
        model_type: self.class.to_s
      ).first

      return unless permalink_redirect.nil?

      # Create the redirect entry to this model.
      Spree::PermalinkRedirect.create!(
        permalink:  permalink_was,
        model_id:   id,
        model_type: self.class.to_s
      )
    end
  end
end
