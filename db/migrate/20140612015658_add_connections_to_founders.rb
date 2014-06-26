class AddConnectionsToFounders < ActiveRecord::Migration
  def change
    add_column :founders, :connections, :integer
  end
end
