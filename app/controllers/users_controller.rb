class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @task_lists = TaskList.where(user_id: @user.id) if TaskList.find_by(user_id: @user.id)
    @task_list = TaskList.new
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = params[:user] ? User.new(user_params) : User.new_guest
    # @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        if current_user && current_user.guest? 
          #guest user who is now signing up
          signup_guest @user
          format.html { redirect_to current_user, notice: ["Thanks for signing up!"] }
          format.json { render action: 'show', status: :created, location: @user }
        elsif @user.username.nil?
          # creates a guest account
          make_account @user
          format.html { redirect_to current_user, notice: ["Thanks for trying this boring list app!"] }
          format.json { render action: 'show', status: :created, location: @user }
        else
          # user who signs up without trying it as a guest first.
          make_account @user 
          format.html { redirect_to current_user, notice: ["Thanks for signing up!"] }
          format.json { render action: 'show', status: :created, location: @user }
        end
      else
        format.html { redirect_to new_user_path, alert: @user.errors.full_messages }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: ['Your info was updated.'] }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if signed_in? && current_user == @user
      @user.destroy
      respond_to do |format|
        format.html { redirect_to root_url, notice: ["#{@user.username}, your account and all information was successfully removed."] }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation, :guest)
    end

    
end
