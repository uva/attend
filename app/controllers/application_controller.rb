class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    return User.find_by(uvanetid: session[:cas_user])
  end

  def is_assistant?
    render text: 'no assistant' if current_user.nil?
  end

  def is_admin?
    render text: 'no admin' if current_user.nil? || !current_user.is_admin?
  end
end
