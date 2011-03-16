class SudasController < ApplicationController
  before_filter :login_required
  
  require 'oauth/consumer'
  def self.consumer
    key = APP_CONFIG['twitter_key']
    secret = APP_CONFIG['twitter_secret']
    OAuth::Consumer.new(key, secret,{ :site=>"http://twitter.com" })
  end
  
  def create
    suda = current_user.sudas.build(params[:suda])
    # suda.message = suda.message[0..290]
    suda.created_at = Time.now #HACK
    agent = agent_name
    suda.agent = agent ? agent : 'Web'
    suda.save!
    if(params[:twit]=='yes')
      if suda.message[(/RS @/)]
        flash[:error] = "Resuda can not send to twitter."
        redirect_to root_path
        return
      end
      if suda.message[(/@(?:[a-zA-Z0-9\-_])/)]
        flash[:error] = "Reply can not send to twitter."
        redirect_to root_path
        return
      end
      http_host = APP_CONFIG['http_host']
      @request_token = SudasController.consumer.get_request_token(:oauth_callback => "http://#{http_host}/twitter_callback")
      session[:request_token] = @request_token.token
      session[:request_token_secret] = @request_token.secret
      session[:twitter_post] = suda.message
      session[:last_suda_id] = suda.id
      redirect_to @request_token.authorize_url
      return
    end
    if APP_CONFIG['use_mail']
      followers = current_user.friends_of
      followers.each do |follower|
        UserMailer.new_suda(follower, current_user, suda.message).deliver
      end
    end
    redirect_to root_path
  end
  
  def twitter_callback
    @request_token = OAuth::RequestToken.new(SudasController.consumer, session[:request_token],session[:request_token_secret])
    @access_token = @request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
    @response = SudasController.consumer.request(:post, '/statuses/update.json', @access_token, {}, { :status => session[:twitter_post] })
    Suda.find_by_id(session[:last_suda_id]).update_attribute(:twitted, 1)
    session[:request_token] = nil
    session[:request_token_secret] = nil
    session[:twitter_post] = nil
    session[:last_suda_id] = nil
    case @response
    when Net::HTTPOK
      flash[:notice] = "To post to twitter succeed."
    else
      flash[:error] = "To post to twitter failed."
    end
    redirect_to root_path
  end
  
  def agent_name
    agent = request.headers["HTTP_USER_AGENT"].downcase
    if agent[/(blackberry)/]
      "Blackberry"
    elsif agent[/(iphone)/]
      "iPhone"
    elsif agent[/(android)/]
      "Android"
    elsif agent[/(ipod)/]
      "iPod"
    elsif agent[/(symbian)/]
      "Symbian"
    elsif agent[/(ipad)/]
      "iPad"  
    elsif agent[/(palm)/]
      "Palm"  
    elsif agent[/(windows ce)/]
      "Windows CE"  
    elsif agent[/(psp)/]
      "PSP"  
    else
      "web"
    end
  end

  def destroy
  end
end
