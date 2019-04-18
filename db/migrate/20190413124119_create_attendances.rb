class CreateAttendances < ActiveRecord::Migration[5.0]
  def change
    create_table :attendances do |t|
      t.integer :num_of_extra_guests, default: 0

      t.belongs_to :guest, index: true
      t.belongs_to :event, index: true

      t.timestamps
    end
  end
end
