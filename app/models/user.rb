class User < ActiveRecord::Base
  # before_save { self.username = username.downcase }
  validates :password, length: { minimum: 6 }
  validates :username, presence: true, length: { maximum: 50 }
  has_many :task_lists
  has_secure_password
end
