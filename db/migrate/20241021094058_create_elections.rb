class CreateElections < ActiveRecord::Migration[7.1]
  def change
    create_table :elections do |t|
      t.string :year
      t.string :name, index: { unique: true }

      t.timestamps
    end
  end
end
