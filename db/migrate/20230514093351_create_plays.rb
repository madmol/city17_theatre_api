class CreatePlays < ActiveRecord::Migration[6.1]
  def change
    create_table :plays do |t|
      t.string :title, null: false
      t.daterange :date_range, null: false

      t.timestamps
    end
  end
end
