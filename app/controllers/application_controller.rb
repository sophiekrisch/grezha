class ApplicationController < ActionController::Base
  protect_from_forgery

  def ping
    render json: { status: :alive }
  end

  def login(user)
    cookies.permanent[:remember_token] = user.remember_token
    @current_user = user
  end

  def logout
    cookies.delete(:remember_token)
    @current_user = nil
  end

  def admin?
    @current_user.admin?
  end

  def logged_in?
    !current_user.nil?
  end
  helper_method :logged_in?

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end
  helper_method :current_user

  def remote_id?(id)
    id =~ /[A-Za-z0-9]{8}/
  end

  private

  def require_admin
    redirect_to(root_path) unless admin?
  end

  def require_logged_in
    redirect_to(login_path) unless logged_in?
  end

  def require_logged_out
    redirect_to(root_path) unless !logged_in?
  end
end
