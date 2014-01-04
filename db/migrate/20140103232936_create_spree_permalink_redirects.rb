class CreateSpreePermalinkRedirects < ActiveRecord::Migration
  def change
    create_table :spree_permalink_redirects do |t|
      t.string      :permalink,     null: false
      t.integer     :model_id,      null: false
      t.string      :model_type,    null: false
      t.timestamps
    end

    add_index :spree_permalink_redirects, :permalink
    add_index :spree_permalink_redirects, [:permalink, :model_id, :model_type], unique: true, name: 'id_type_permalink'
  end
end
