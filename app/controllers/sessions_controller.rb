class SessionsController < ApplicationController

  def create

    logger.info "Auth-Hash: #{auth_hash}"
    user = auth_service.handle_auth_success auth_hash
    logger.info "User: #{user.try(:inspect)}"
    self.session_user_id = user.id
    self.remember_me = user.id
    redirect_to '/'
  end

  def clear
    session.clear
    self.remember_me = nil
    redirect_to '/'
  end

private

  def auth_service
    @auth_service ||= AuthService.new
  end

  def auth_hash
    request.env['omniauth.auth']
  end
end
