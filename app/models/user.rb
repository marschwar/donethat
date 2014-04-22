class User < ActiveRecord::Base

  # Dragonfly image
  dragonfly_accessor :avatar

  def avatar_navigation_path
    avatar.process(:resize, '42^').process(:crop, width: 42, height: 42, gravity: 'c').url
  end

end
