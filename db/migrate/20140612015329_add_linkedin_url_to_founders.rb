class AddLinkedinUrlToFounders < ActiveRecord::Migration
  def change
    add_column :founders, :linkedin_url, :string
  end
end
