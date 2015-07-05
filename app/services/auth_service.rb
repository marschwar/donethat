class AuthService

  def handle_auth_success(auth_hash)
    # see https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
    user_type = user_class_name auth_hash[:provider]

    user = User.find_by_type_and_identifier(user_type, auth_hash[:uid])
    unless user
      user = User.new
      user.type = user_type
      user.identifier = auth_hash[:uid]
    end
    info = auth_hash[:info]
    user.name = info[:name]
    user.remote_avatar_url = info[:image] if info[:image]
    user.password = auth_hash[:credentials][:token]

    user.save!

    user
  end

private

  def user_class_name(provider)
    clazz = Donethat::Application.config.omniauth_provider_mapping[provider.to_sym]
    clazz ? clazz : "#{provider.camelize}User"
  end
end