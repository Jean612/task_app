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
  end

  def update
    @view = params[:task][:view]
    respond_to do |format|
      if @task.update(task_params.except(:view))
        format.html { redirect_to tasks_path }
        flash.now[:notice] = "Se editó la tarea correctamente"
        format.turbo_stream
      else
        format.html { redirect_to tasks_path }
        flash.now[:alert] = "Ocurrió un error al editar la tarea"
        format.turbo_stream { render turbo_stream: turbo_stream.update("flash", partial:"layouts/shared/flash_messages") }
      end
    end
  end

  def new
    @task = Task.new
    @view = "card"
  end
  
  def dashboard_add
    @task = Task.new(state: params[:state])
    @view = "dashboard"
  end

  def create
    @view = params[:task][:view]
    @task = Task.new(task_params.except(:view))
    @task.user = current_user
    
    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_path }
        flash.now[:notice] = "Se añadió la tarea correctamente"
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        flash.now[:alert] = "Ocurrio un error al crear la tarea"      
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("flash", partial:"layouts/shared/flash_messages"),
            turbo_stream.update("show_content_modal", partial: 'form')
          ] 
        end
      end
    end
  end

  def destroy
    @view = params[:view]
    respond_to do |format|
      if @task.destroy
        format.html { redirect_to tasks_path }
        #flash.now[:notice] = "Se eliminó la tarea correctamente"
        format.turbo_stream
      else
        format.html { redirect_to tasks_path, notice: @task.errors.full_message }
        #flash.now[:alert] = "Ocurrió un error al eliminar la tarea"
        #format.turbo_stream { render turbo_stream: turbo_stream.update("flash", partial:"layouts/shared/flash_messages") }
      end
    end
  end
  
  def order_list
    
    if params[:field].present?
      @tasks = @tasks.order("#{params[:field]} #{params[:order]}") if params[:field] == "created_at" 
      if params[:field] == "priority"
        @tasks = params[:order] == "asc" ? @tasks.order_by_priority_asc : @tasks.order_by_priority_desc
      end
      @tasks = @tasks.order_by_state_asc if params[:field] == "state"
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
