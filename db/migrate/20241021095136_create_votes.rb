class CreateVotes < ActiveRecord::Migration[7.1]
  def change
    create_table :votes do |t|
      t.belongs_to :voter, null: false, foreign_key: true
      t.belongs_to :candidate, null: false, foreign_key: true
      t.belongs_to :election, null: false, foreign_key: true

      t.timestamps
    end
  end
end
