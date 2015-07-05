require 'carrierwave/orm/activerecord'

class User < ActiveRecord::Base

  has_secure_password

  mount_uploader :avatar, AvatarUploader

end
