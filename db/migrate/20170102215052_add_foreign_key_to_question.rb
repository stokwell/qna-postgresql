class AddForeignKeyToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :questions, :seminars
  end
end
