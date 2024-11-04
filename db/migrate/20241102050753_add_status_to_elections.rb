class AddStatusToElections < ActiveRecord::Migration[7.1]
  def change
    add_column :elections, :status, :integer
  end
end
