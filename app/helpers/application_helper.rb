module ApplicationHelper
   
   def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
  self.current_user = nil
  cookies.delete(:remember_token)
  end

  def signed_in_user
      unless signed_in?
        flash[:alert] = ["Please sign in!"]
        redirect_to root_url 
      end
    end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def create_list(user)
    @list = TaskList.create(name: "Default List", user_id: user.id)
  end

  def complete?
    self.complete == true ? true : false
  end
end