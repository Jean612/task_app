class TasksController < ApplicationController
  def index
    @tasks = Task.where(user_id: current_user.id)
  end

  def show
  end

  def edit
  end

  def update
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.user = current_user
    
    if @task.save
      redirect_to tasks_path
    else
      render :new
    end
  end

  def destroy
  end
  
  private
  
  def task_params
    params.require(:task).permit(:title, :description, :state, :priority, :deadline)
  end
end
