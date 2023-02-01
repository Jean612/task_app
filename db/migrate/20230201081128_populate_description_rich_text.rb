class PopulateDescriptionRichText < ActiveRecord::Migration[7.0]
  def change
    Task.all.each do |task|
      if task.description.present?
        ActionText::RichText.create!(record_type: 'Task', record_id: task.id, name: 'content', body: task.description)
      end
    end
  end
end
