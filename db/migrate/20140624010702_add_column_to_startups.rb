class AddColumnToStartups < ActiveRecord::Migration
  def change
    add_column :startups, :angellist_url, :string
  end
end
