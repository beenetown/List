class TasksController < ApplicationController
  before_action :set_task, except: [:create, :check_all, :uncheck_all, :destroy_complete]
  before_action :set_task_list_id
  before_action :set_task_list, except: :new
  before_action :signed_in_user

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)
    respond_to do |format|
      if @task.save
        format.html { redirect_to task_list_path(@task_list_id), notice: ['Task was added'] }
        format.js {}
        format.json { render action: 'show', status: :created, location: @task }
      else
        format.html { redirect_to task_list_path(@task_list_id), alert: @task.errors.full_messages }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def complete
    respond_to do |format|
      if @task.complete == false
        @task.update_attributes(complete: true)
        format.html { redirect_to task_list_path(@task_list_id), notice: ['Task was completed.'] }
        format.js 
        format.json { head :no_content }
      else
        format.html { redirect_to task_list_path(@task_list_id), alert: ['Task was not updated.'] }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def incomplete
    respond_to do |format|
      if @task.complete == true
        @task.update_attributes(complete: false)
        format.html { redirect_to task_list_path(@task_list_id), notice: ['Task status updated.'] }
        format.js
        format.json { head :no_content }
      else
        format.html { redirect_to task_list_path(@task_list_id), alert: ['Task was not updated.'] }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to task_list_path(@task_list_id), alert: ["Task deleted"] }
      format.js
      format.json { head :no_content }
    end
  end

  def destroy_complete
    @task_list.delete_completed

    respond_to do |format|
      format.html { redirect_to task_list_path(@task_list_id), alert: ["Updated all"] }
      format.js
      format.json { head :no_content }
    end
  end

  def check_all
    @task_list.all_check

    respond_to do |format|
      format.html { redirect_to task_list_path(@task_list_id) }
      format.js
      # format.json { head :no_content }
    end
  end

  def uncheck_all
    @task_list.all_uncheck

    respond_to do |format|
      format.html { redirect_to task_list_path(@task_list_id) }
      format.js
      # format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    def set_task_list_id
      @task_list_id = session[:task_list_id].to_s
    end

    def set_task_list
      @task_list = TaskList.find(@task_list_id)
    end

    def task_params
      params.require(:task).permit(:task, :complete, :task_list_id)
    end
end
