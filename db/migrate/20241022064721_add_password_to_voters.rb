class AddPasswordToVoters < ActiveRecord::Migration[7.1]
  def change
    add_column :voters, :password_digest, :string
  end
end
