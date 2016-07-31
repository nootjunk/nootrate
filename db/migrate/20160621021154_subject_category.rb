class SubjectCategory < ActiveRecord::Migration
  def change
  	  	add_column :subjects, :category, :integer, default: 0
  end
end
