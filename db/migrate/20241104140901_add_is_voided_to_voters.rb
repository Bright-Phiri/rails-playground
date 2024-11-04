class AddIsVoidedToVoters < ActiveRecord::Migration[7.1]
  def change
    add_column :voters, :is_voided, :boolean, default: false
  end
end
