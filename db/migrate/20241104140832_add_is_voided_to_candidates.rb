class AddIsVoidedToCandidates < ActiveRecord::Migration[7.1]
  def change
    add_column :candidates, :is_voided, :boolean, default: false
  end
end
