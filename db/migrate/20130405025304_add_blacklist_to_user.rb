class AddBlacklistToUser < ActiveRecord::Migration
  def change
    add_column :users, :blacklist, :string
  end
end
