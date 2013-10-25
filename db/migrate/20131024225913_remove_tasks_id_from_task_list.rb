class RemoveTasksIdFromTaskList < ActiveRecord::Migration
  def change
    remove_column :task_lists, :task_id, :integer
  end
end
