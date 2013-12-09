class AddDefaultValueToCompleteInTasks < ActiveRecord::Migration
  def change
    # change_column :table_name, :column_name, :type, default: "Your value"
    change_column :tasks, :complete, :boolean, default: false    
  end
end
