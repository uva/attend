class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    return User.find_by(uvanetid: session[:cas_user])
  end

  def is_assistant?
    if current_user.nil?
      redirect_to controller: 'users', action: 'unauthorized'
    end
  end

  def is_admin?
    if current_user.nil? || !current_user.is_admin?
      redirect_to controller: 'users', action: 'unauthorized'
    end
  end
end
