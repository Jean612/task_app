class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :update_state]
  before_action :set_tasks, only: [:create, :destroy, :order_list]
  
  def index
    @tasks = Task.where(user_id: current_user.id)
  end

  def show
  end

  def edit
    @view = params[:view]
    p @view
  end

  def update
    @view = params[:task][:view]
    p @view
    if @task.update(task_params.except(:view))
      respond_to do |format|
        format.html { redirect_to tasks_path }
        format.turbo_stream
      end
    else
      render :edit
    end
  end

  def new
    @task = Task.new
    @view = "card"
  end
  
  def dashboard_add
    @task = Task.new
    @view = "dashboard"
  end

  def create
    @view = params[:task][:view]
    @task = Task.new(task_params.except(:view))
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
    @view = params[:view]
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
    
    render turbo_stream: turbo_stream.replace("tasks_list", partial: 'task_card_view', locals: { tasks: @tasks })
  end
  
  def update_state
    if @task.update(state: params[:state])
      render json: { message: "Se actualizó la tarea #{@task.title}", error: false}
    else   
      render json: { message: "Ocurrió un error al actualizar la tarea", error: true}
    end
  end
  
  private
  
  def set_task
    @task = Task.find(params[:id])
  end
  
  def set_tasks
    @tasks = Task.where(user_id: current_user.id)
  end
  
  def task_params
    params.require(:task).permit(:title, :description, :state, :priority, :deadline, :view)
  end
end
