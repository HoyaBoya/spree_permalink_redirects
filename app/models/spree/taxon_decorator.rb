module Spree
  Taxon.class_eval do
    include Spree::PermalinkHelper

    # TODO: after_save does not capture permalink_changed?
    # This needs to be investigated.... :(
    before_save :handle_permalink_changed, :if => :permalink_changed?
  end
end
