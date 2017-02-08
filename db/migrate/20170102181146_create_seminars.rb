class CreateSeminars < ActiveRecord::Migration[5.0]
  def change
    create_table :seminars do |t|
      t.string :theme
      t.string :date
      t.text :lecture
      t.references :course, foreign_key: true
      
      t.timestamps
    end
  end
end
