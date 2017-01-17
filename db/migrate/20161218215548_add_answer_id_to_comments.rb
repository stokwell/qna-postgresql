class AddAnswerIdToComments < ActiveRecord::Migration[5.0]
  def change
     rename_column :comments, :answers_id, :answer_id
  end
end
