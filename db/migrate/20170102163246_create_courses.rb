class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.string :theme
      t.text :description
      t.string :semester
      t.string :instructor
      t.string :time 
      t.integer :user_id
      t.timestamps
    end
  end
end
