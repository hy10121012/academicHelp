class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authorize, :except =>[:welcome,:register,:login,:login_check]

  def login?
    return !session[:user_id].nil?
    #@current_user ||= User.find(session[:user_id])
  end

  def authorize
    puts session[:user_type_id]
    if !login?
      redirect_to "/";
    end
  end




end
