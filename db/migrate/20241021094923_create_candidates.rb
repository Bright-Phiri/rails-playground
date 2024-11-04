class CreateCandidates < ActiveRecord::Migration[7.1]
  def change
    create_table :candidates do |t|
      t.string :name
      t.belongs_to :position, null: false, foreign_key: true
      t.belongs_to :election, null: false, foreign_key: true

      t.timestamps
    end
  end
end
