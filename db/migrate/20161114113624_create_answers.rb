class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :title
      t.text :body
      t.references :question, foreign_key: true
      t.timestamps null: false
    end
  end
end