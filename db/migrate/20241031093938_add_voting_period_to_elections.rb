class AddVotingPeriodToElections < ActiveRecord::Migration[7.1]
  def change
    add_column :elections, :start_time, :datetime
    add_column :elections, :end_time, :datetime
  end
end
