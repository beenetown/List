class User < ActiveRecord::Base
  # before_save { self.username = username.downcase }
  validates :password, presence: true, length: { minimum: 6 }
  validates :username, presence: true, length: { maximum: 50 }, uniqueness: true
  has_many :task_lists, dependent: :destroy
  before_create :create_remember_token
  has_secure_password


  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
