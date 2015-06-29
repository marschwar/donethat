class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_current_user

private
  def set_current_user
    id = session_user_id || remember_me
    @user = User.find(id) if id
  end

  def remember_me
    logger.info "remember_me cookie is #{cookies.signed[:remember_me]}"
    cookies.signed[:remember_me]
  end

  def remember_me=(value)
    logger.info "Setting remember_me cookie to #{value}"
    cookies.permanent.signed[:remember_me] = value
  end

  def session_user_id
    session[:user_id]
  end

  def session_user_id=(value)
    logger.info "Setting session_user_id to #{value}"
    session[:user_id] = value
  end
end
