class AnonymizeComments < ActiveRecord::Migration
  def change
  	remove_column :comments, :user
  	remove_column :comments, :user_name
  end
end
