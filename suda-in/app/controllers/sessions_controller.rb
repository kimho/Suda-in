class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:login], params[:password])
    if user
      session[:user_id] = user.id
      flash[:notice] = "Logged in successfully."
      redirect_to_target_or_default("/")
    else
      flash.now[:error] = "Invalid login or password."
      render :action => 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    session[:request_token] = nil
    session[:request_token_secret] = nil
    session[:twitter_post] = nil
    flash[:notice] = "You have been logged out."
    redirect_to "/"
  end
  
end
