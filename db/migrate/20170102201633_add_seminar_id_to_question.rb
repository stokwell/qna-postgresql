class AddSeminarIdToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :seminar_id, :integer
  end
end
