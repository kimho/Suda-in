class HomeController < ApplicationController
  before_filter :login_required
  
  def index
    @sudas = current_user.our_sudas(1)
    @last_suda = current_user.sudas.last
    
    if params[:in_reply_to]
      @suda_value = "@#{params[:in_reply_to]} "
    elsif params[:in_resuda_of]
      suda_id = params[:in_resuda_of]
      suda = Suda.find_by_id(suda_id)
      user = User.find_by_id(suda.user_id)
      @suda_value = "RS @#{user.username}: #{suda.message}"
    else
      @suda_value = ''
    end
  end
  
  def rss
    @sudas = current_user.our_sudas(1)
    render :layout => false
    response.headers["Content-Type"] = "application/xml; charset=utf-8"
  end
  
  def all
    @sudas = Suda.all_sudas(1)
    @last_suda = current_user.sudas.last
    render :template => "/home/index", :locals => { :sudas => @sudas }
  end
  
  def all_rss
    @sudas = Suda.all_sudas(1)
    render :layout => false
    response.headers["Content-Type"] = "application/xml; charset=utf-8"
  end
  
  def show
    @user = User.find_by_username(params[:username])
    if @user
      @sudas = @user.my_sudas(1)
    else
      render :text => "<h3>There is no <font color='red'>#{params[:username]}</font></h3>"
    end
  end
  
  def user_rss
    @user = User.find_by_username(params[:username])
    if @user
      @sudas = @user.my_sudas(1)
    end
    render :layout => false
    response.headers["Content-Type"] = "application/xml; charset=utf-8"
  end
   
  def toggle_follow
    @user = User.find_by_username(params[:username])
    if current_user.is_friend? @user
      flash[:notice] = "You are no longer following @#{@user.username}"
      current_user.remove_friend(@user)
    else
      flash[:notice] = "You are now following @#{@user.username}"
      current_user.add_friend(@user)
    end
    redirect_to user_sudas_path(@user.username)
  end

  def toggle_follow_via_ajax
    user = User.find_by_username(params[:username])
    if current_user.is_friend? user
      current_user.remove_friend(user)
    else
      current_user.add_friend(user)
    end
    render :text => user.id
  end  
  
  def more_suda
    @sudas = current_user.our_sudas(params[:page])
    render :partial => "/includes/sudas_list", :locals => { :sudas => @sudas }
  end
  
  def more_all_suda
    @sudas = Suda.all_sudas(params[:page])
    render :partial => "/includes/sudas_list", :locals => { :sudas => @sudas }
  end
  
  def more_show_suda
    @user = User.find_by_username(params[:username])
    if @user
      @sudas = @user.my_sudas(params[:page])
    end
    render :partial => "/includes/sudas_list", :locals => { :sudas => @sudas }
  end
  
  def more_search_suda
    @q = params[:q]
    @page = params[:page]
    unless @page
      @page = 0
    end
    @sudas = Suda.find_by_search_query(@q, @page)
    render :partial => "/includes/sudas_list", :locals => { :sudas => @sudas }
  end
  
  def del_suda
    suda_id = params[:id]
    suda = Suda.find_by_id(suda_id)
    if suda.user_id != current_user.id
      result = {'code'=>'error','msg'=>"You can not delete other's suda."}
    elsif suda.created_at < 1.days.ago.to_date
      result = {'code'=>'error','msg'=>"You can not delete suda after 1 day."}
    else 
      suda.destroy
      result = {'code'=>'success','id'=>suda_id}
    end
    render :text => ActiveSupport::JSON.encode(result)
  end
  
  def following
    @friends = current_user.friends
  end
  
  def followers
    @friends = current_user.friends_of
  end
  
  def people
    if params[:person]
      @people = User.find(:all, :conditions=>["username like ? or nickname like ?", "%#{params[:person]}%", "%#{params[:person]}%"], :order => "created_at desc")
    else
      @people = User.all.sort_by{rand}.delete_if {|u| u.sudas.last==nil } 
    end
  end
  
  def remove_friend
    friend = User.find_by_username(params[:username])
    if friend
      current_user.remove_friend(friend)
      render :text => friend.id
    else
      render :text => friend.id
    end
  end
  
  def search 
    @q = params[:q]
    @page = params[:page]
    unless @page
      @page = 0
    end
    @sudas = Suda.find_by_search_query(@q, @page)
    render :template => '/home/index', :locals => { :sudas => @sudas }
  end
  
  def search_rss
    @q = params[:q]
    @page = params[:page]
    unless @page
      @page = 0
    end
    @sudas = Suda.find_by_search_query(@q, @page)
    render :layout => false
    response.headers["Content-Type"] = "application/xml; charset=utf-8"
  end
end
