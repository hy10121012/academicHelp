class AdministratorController < ApplicationController
  layout 'admin'

  def verify_maker
    @users = User.get_maker_unverify_list
  end

  def do_verify_maker
    user = User.find(params[:user][:id])
    if(params[:user][:action]=='1')
      user.is_validated=true
      WriterMailer.send_taker_validation_mail(user,1,params[:user][:reason]).deliver
    elsif(params[:user][:action]=='0')
      user.is_validated=false
      WriterMailer.send_taker_validation_mail(user,0,params[:user][:reason]).deliver
    end
    user.save
    redirect_to :action => :verify_maker
  end

  def verify_taker
  end

  def home

  end


end
