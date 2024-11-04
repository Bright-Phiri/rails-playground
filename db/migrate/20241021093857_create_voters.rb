class CreateVoters < ActiveRecord::Migration[7.1]
  def change
    create_table :voters do |t|
      t.string :name
      t.string :email, index: { unique: true }

      t.timestamps
    end
  end
end
