class WelcomeController < ApplicationController
  def welcome
    render layout: 'welcome'
  end

  def login

  end
  def login_check
    user = User.find_by_email(params[:email])
    if(!user.nil?)
      if(user.password==params[:password])
        session[:user_id]= user.id;
        session[:user_type_id]= user.user_type_id;
        redirect_to '/home'
      end
    end
  end


  def register
    render layout: 'application'
  end

end
