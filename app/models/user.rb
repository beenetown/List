class User < ActiveRecord::Base
  # before_save { self.username = username.downcase }
  validates_presence_of :username, :password, unless: :guest?
  validates :password, length: { minimum: 6 }, unless: :guest?
  validates :username, length: { maximum: 50 }, unless: :guest?
  validates_uniqueness_of :username, allow_blank: true
  has_many :task_lists, dependent: :destroy 
  before_create :create_remember_token
  has_secure_password validations: false


  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def self.new_guest
    new { |u| u.guest = true }
  end

  def name
    guest ? "Guest" : username
  end

  def move_to(user)
    task_lists.update_all(user_id: user.id)
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
