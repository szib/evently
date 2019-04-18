class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.datetime :date
      t.string :venue

      t.belongs_to :admin, index: true

      t.timestamps
    end
  end
end
