class AddDetailsToElections < ActiveRecord::Migration[7.1]
  def change
    add_column :elections, :candidates_count, :integer, default: 0
    add_column :elections, :votes_count, :integer, default: 0
  end
end
