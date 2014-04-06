class Api::AuthController < ActionController::Base

  def twitter_auth
    identifier = params[:identifier]
    logger.info "Requested twitter auth for #{identifier}"
    token = auth_token TwitterUser.find_by_identifier identifier
    if token
      render json: token
    else
      head(:not_found)
    end
  end

private

  # creates a hash with the current timestamp and the users id encrypted with the server
  # key and then with the user secret
  def auth_token(user)
    if user
      hash = { ts: Time.now.to_i, ip: request.env['REMOTE_ADDR'], id: user.id }
      token = crypto_service.encrypt_server_hash hash
      logger.info "server token #{token}"
      { token: crypto_service.encrypt_string(token, user.secret) }
    end
  end

  def crypto_service
    @crypto_service ||= CryptoService.new
  end
end