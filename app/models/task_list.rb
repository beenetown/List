class TaskList < ActiveRecord::Base
  has_many :tasks, dependent: :destroy
  belongs_to :user
  # accepts_nested_attributes_for :tasks
  validates :name, presence: true
  validates :user_id, presence: true

  def all_check 
    task_list = Task.where(task_list_id: self.id)
    task_list.each { |task| task.update_attributes(complete: true)}
  end

  def all_uncheck
    task_list = Task.where(task_list_id: self.id)
    task_list.each { |task| task.update_attributes(complete: false)}      
  end

  def delete_completed
    task_list = Task.where(task_list_id: self.id)
    task_list.where(complete: true).all.each { |task| task.destroy }
  end
end