class RemoveTasksFromTaskList < ActiveRecord::Migration
  def change
    remove_column :task_lists, :tasks, :string
  end
end
