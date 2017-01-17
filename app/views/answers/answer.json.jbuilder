json.extract! @answer, :id, :question_id, :body, :user_id
json.update_url  question_answers_path(@question, @answer)
json.destroy_url question_answers_path(@question, @answer)
json.question @question, :id, :title, :body, :user_id


json.attachments @answer.attachments do |attach|
  json.id attach.id
  json.file_name attach.file.identifier
  json.file_url attach.file.url
end