class CreateFounders < ActiveRecord::Migration
  def change
    create_table :founders do |t|
      t.references :startup, index: true

      t.timestamps
    end
  end
end
