class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :set_tasks, only: [:create, :destroy, :order_list]
  
  def index
    @tasks = Task.where(user_id: current_user.id)
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to tasks_path }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("task_#{@task.id}", partial: 'task_item', locals: { task: @task }) }
      else
        format.html { redirect_to edit_task_path }
      end
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user = current_user
    
    if @task.save
      respond_to do |format|
        format.html { redirect_to tasks_path }
        format.turbo_stream
      end
    else
      render :new
    end
  end

  def destroy
     respond_to do |format|
      if @task.destroy
        format.html { redirect_to tasks_path }
        format.turbo_stream
      else
        format.html { redirect_to tasks_path, notice: @task.errors.full_message }
      end
    end
  end
  
  def order_list
    
    if params[:field].present?
      @tasks = @tasks.order("#{params[:field]} #{params[:order]}") if params[:field] == "created_at"
      @tasks = @tasks.in_order_of(:priority, params[:order] == "asc" ? Task::SORT_ORDER_PRIORITY : Task::SORT_ORDER_PRIORITY.reverse ) if params[:field] == "priority"
      @tasks = @tasks.in_order_of(:state, Task::SORT_ORDER_STATE) if params[:field] == "state"
    else
      @tasks.order(id: :desc)
    end
    
    render turbo_stream: turbo_stream.replace("tasks_list", partial: 'task_list', locals: { tasks: @tasks })
  end
  
  private
  
  def set_task
    @task = Task.find(params[:id])
  end
  
  def set_tasks
    @tasks = Task.where(user_id: current_user.id)
  end
  
  def task_params
    params.require(:task).permit(:title, :description, :state, :priority, :deadline)
  end
end
