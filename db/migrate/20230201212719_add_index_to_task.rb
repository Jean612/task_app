class AddIndexToTask < ActiveRecord::Migration[7.0]
  def change
    add_index :tasks, :deadline
    add_index :tasks, :priority
    add_index :tasks, :state
    add_index :tasks, :title
    add_index :tasks, :created_at
  end
end
