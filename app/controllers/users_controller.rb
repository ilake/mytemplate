# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:edit, :update]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save_without_session_maintenance
      @user.deliver_activation_instructions!
      flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
      redirect_back_or_default root_path
    else
      render :action => 'new'
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated user."
      redirect_to current_user
    else
      render :action => 'edit'
    end
  end

  def resend_activation
    if params[:login]
      @user = User.find_by_nickname params[:login]
      if @user && !@user.active?
        @user.deliver_activation_instructions!
        flash[:notice] = "Please check your e-mail for your account activation instructions!"
        redirect_to root_path
      end
    end
  end

end
