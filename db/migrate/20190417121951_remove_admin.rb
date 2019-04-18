class RemoveAdmin < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :admin_id
    drop_table :admins
  end
end
