class AddNameToFounders < ActiveRecord::Migration
  def change
    add_column :founders, :name, :string
  end
end
