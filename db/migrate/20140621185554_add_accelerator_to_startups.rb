class AddAcceleratorToStartups < ActiveRecord::Migration
  def change
    add_column :startups, :accelerator, :string
  end
end
