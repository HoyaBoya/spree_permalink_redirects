class Spree::PermalinkRedirect < ActiveRecord::Base
  def model
    model_type.constantize.find(model_id)
  end
end
