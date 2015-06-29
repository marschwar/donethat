class FilesController < ApplicationController

  def avatar

    user = User.find params[:user_id]
#    raise 'error' unless "#{params[:file_name]}.png" = user.avatar.thumb.

    file = user.avatar.thumb

    send_file( file.path,
      :disposition => 'inline',
      type: file.content_type,
      :x_sendfile => true )
  end
end
