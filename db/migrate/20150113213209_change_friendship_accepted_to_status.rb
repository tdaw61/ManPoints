class ChangeFriendshipAcceptedToStatus < ActiveRecord::Migration
  def change
    rename_column :friendships, :accepted, :status
  end
end
