class TaskListsController < ApplicationController
  before_action :set_task_list, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user


  # GET /task_lists
  # GET /task_lists.json
  def index
    @task_lists = TaskList.all
  end

  # GET /task_lists/1
  # GET /task_lists/1.json
  def show
    session[:task_list_id] = @task_list.id
    @task_list_id = session[:task_list_id]
    @task = Task.new
  end

  # GET /task_lists/new
  def new
    @task_list = TaskList.new
  end

  # GET /task_lists/1/edit
  def edit
  end

  # POST /task_lists
  # POST /task_lists.json
  def create
    @task_list = TaskList.new(task_list_params)

    respond_to do |format|
      if @task_list.save
        format.html { redirect_to @task_list, notice: ['Task list was created.'] }
        format.js
        format.json { render action: 'show', status: :created, location: @task_list }
      else
        format.html { redirect_to current_user, alert: @task_list.errors.full_messages }
        format.json { render json: @task_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /task_lists/1
  # PATCH/PUT /task_lists/1.json
  def update
    respond_to do |format|
      if @task_list.update(task_list_params)
        format.html { redirect_to @task_list, notice: ['Task list was updated.'] }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @task_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_lists/1
  # DELETE /task_lists/1.json
  def destroy
    @task_list.destroy
    @task_lists = TaskList.where(user_id: current_user.id) if TaskList.find_by(user_id: current_user.id)
    # @task_list = TaskList.new
    respond_to do |format|
      # format.html { redirect_to current_user, notice: ["#{@task_list.name} was deleted."] }
      format.js 
      # format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task_list
      @task_list = TaskList.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_list_params
      params.require(:task_list).permit(:tasks, :name, :user_id)
    end
end
