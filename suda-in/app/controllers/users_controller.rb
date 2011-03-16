class UsersController < ApplicationController
  before_filter :login_required, :except => [:new, :create]

  def new
    @user = User.new
  end

  def create
    if APP_CONFIG['use_ldap']
      redirect_to root_path
    end
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Thank you for signing up! You are now logged in."
      redirect_to "/"
    else
      render :action => 'new'
    end
  end

  def edit
    if APP_CONFIG['use_ldap']
      redirect_to root_path
    end
    @user = current_user
  end

  def update
    if APP_CONFIG['use_ldap']
      redirect_to root_path
    else
      @user = current_user
      if @user.update_attributes(params[:user])
        flash[:notice] = "Your profile has been updated."
        redirect_to "/"
      else
        render :action => 'edit'
      end
    end
  end
end
