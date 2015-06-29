require 'carrierwave/orm/activerecord'

class User < ActiveRecord::Base

  mount_uploader :avatar, AvatarUploader

end
