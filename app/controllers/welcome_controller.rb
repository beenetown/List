class WelcomeController < ApplicationController
  def index
    redirect_to current_user if signed_in?
  end

  def help
  end

  def contact
  end
end
