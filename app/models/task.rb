class Task < ApplicationRecord
  belongs_to :user
  
  SORT_ORDER_STATE = %w(opened to_do paused in_progress revision completed)
  SORT_ORDER_PRIORITY = %w(low middle high urgent)
  
  scope :by_state, -> (state) { where(state: state) }
  scope :order_by_priority_asc, -> { in_order_of(:priority, SORT_ORDER_PRIORITY) } 
  scope :order_by_priority_desc, -> { in_order_of(:priority, SORT_ORDER_PRIORITY.reverse) } 
  scope :order_by_state_asc, -> { in_order_of(:state, SORT_ORDER_STATE) } 
  
  STATES = {
    "opened": "Abierto",
    "to_do": "Por hacer", 
    "paused": "En pausa",
    "in_progress": "En progreso",
    "revision": "En revisión",
    "completed": "Completada"
  }
  
  PRIORITIES = {
    "low": "Baja",
    "middle": "Medio",
    "high": "Alto",
    "urgent": "Para mañana"
  }
  
  validates :title, presence: true
  validates :priority, presence: true
  has_rich_text :content
  has_many_attached :files
  
  before_create :set_initial_state
  
  def abstract
    if self.content.present?
      self.content.to_plain_text.truncate(50)
    else
      return "Sin descripción"
    end
  end
  
  private
  
  def set_initial_state
    return unless self.state.nil?
    self.state = "opened"
  end
end
# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  deadline    :date
#  description :text
#  priority    :string
#  state       :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_tasks_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
