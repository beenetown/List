class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:username] )
    if user && user.authenticate(params[:password])
      sign_in user
      redirect_to user
    else
      flash.now[:alert] = ["That email/password combination does not exist."]
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
