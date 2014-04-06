class Api::ApiController < ActionController::Base

  before_filter :read_auth_token

  def trips
    
  end

private
  def read_auth_token
    token = request.headers['X-Auth-Token']
    ip = request.env['REMOTE_ADDR']
    begin
      if token.present?
        hash = crypto_service.decrypt_server_hash token
        raise "REMOTE_ADDR #{hash['ip']} expected but was #{ip}" if hash['ip'] && hash['ip'] != ip
        @user = User.find(hash['id'])
      end
    rescue Exception => e
      logger.info "#{e}: invalid auth token #{token}"
    end
    head(:unauthorized) unless @user
  end

  def crypto_service
    @crypto_service ||= CryptoService.new
  end
end