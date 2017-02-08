class AddCourseIdToSeminar < ActiveRecord::Migration[5.0]
  def change
    add_column :seminars, :courses_id, :integer
     add_index :seminars, :courses_id
  end
end
