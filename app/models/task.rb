class Task < ActiveRecord::Base
  belongs_to :task_list
  validates :task, presence: true
  default_scope -> { order('created_at DESC') }
end
