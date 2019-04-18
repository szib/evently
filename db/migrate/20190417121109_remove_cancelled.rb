class RemoveCancelled < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :cancelled
  end
end
