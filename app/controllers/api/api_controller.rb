class Api::ApiController < ActionController::Base

  before_filter :authenticate_user

private

  def authenticate_user
    if user_name && password
      @user = User.where(identifier: user_name).select { |u| u.authenticate(password) }.try(:first)
    end
    head(:unauthorized) unless @user
  end

  def crypto_service
    @crypto_service ||= CryptoService.new
  end

  def auth_token
    request.headers['X-Auth-Token']
  end

  def user_name
    extract_auth_token unless @user_name
    @user_name
  end

  def password
    extract_auth_token unless @password
    @password
  end

  def extract_auth_token
    /\A(?<username>.*):(?<password>.*)\Z/ =~ auth_token
    @user_name = username
    @password = password
  end
end