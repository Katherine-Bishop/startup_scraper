class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
      t.integer :founder_id
      t.string :school

      t.timestamps
    end
  end
end
