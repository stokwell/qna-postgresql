class AttachmentsController < ApplicationController
 before_action :authenticate_user!

  def destroy
    @attachment = Attachment.find(params[:id])
      if @attachment.attachable.user_id == current_user.id
        @attachment.destroy
      end
  end

end
