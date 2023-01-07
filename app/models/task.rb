class Task < ApplicationRecord
  belongs_to :user
  
  STATES = {
    "opened": "Abierto",
    "to_do": "Por hacer", 
    "paused": "En pausa",
    "in_progress": "En progreso",
    "revision": "En revisión",
    "completed": "Completada"
  }
  
  PRIORITIES = {
    "middle": "Medio",
    "low": "Baja",
    "high": "Alto",
    "urgent": "Para mañana"
  }
  
  validates :title, presence: true
  validates :priority, presence: true
  has_rich_text :description
  
  before_save :set_initial_state
  
  private
  
  def set_initial_state
    self.state = "opened"
  end
end
