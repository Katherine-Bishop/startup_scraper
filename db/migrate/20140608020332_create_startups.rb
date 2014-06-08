class CreateStartups < ActiveRecord::Migration
  def change
    create_table :startups do |t|
      t.text :name

      t.timestamps
    end
  end
end
