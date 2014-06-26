class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer :founder_id
      t.string :position
      t.string :company
      t.string :company_description

      t.timestamps
    end
  end
end
