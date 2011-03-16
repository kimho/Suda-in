class UserMailer < ActionMailer::Base
  default :from => "#{APP_CONFIG['site_title']} Suda-in <#{APP_CONFIG['administrator_mail']}>"
  def registration_confirmation(user)
    @user = user
    # attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    mail(:to => "#{user.email}", :subject => "Welcome to #{APP_CONFIG['site_title']} Suda-in")
  end
  
  def new_suda(follower, suda_user, suda_message)
    @follower = follower
    @suda_user = suda_user
    @suda_message = suda_message
    mail(:to => "#{follower.email}", :subject => "#{suda_user.username}(#{suda_user.nickname}) did suda in #{APP_CONFIG['site_title']} Suda-in")
  end
end

