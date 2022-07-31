class AddVisibleToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :visible, :boolean
  end
end
