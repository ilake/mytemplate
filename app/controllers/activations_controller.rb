# -*- encoding : utf-8 -*-
class ActivationsController < ApplicationController
  before_filter :require_no_user

  def create
    @user = User.find_using_perishable_token(params[:activation_code], 1.week) || (raise Exception)
    raise Exception if @user.email_active?

    if @user.email_activate!
      flash[:notice] = "Your account has been activated!"
      UserSession.create(@user, false) # Log user in manually
      @user.deliver_welcome!
      redirect_to root_url
    else
      render :action => :new
    end
  end

end
