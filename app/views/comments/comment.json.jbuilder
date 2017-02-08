json.extract! @comment, :id, :body, :user_id, :answer_id
json.user @comment.user, :id

json.destroy_url comment_path(@comment)
