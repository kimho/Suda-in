class CommentsController < ApplicationController
  before_filter :login_required
  
  # create via ajax
  def create
    comment = comments.build(params[:comment])
    comment.user_id = current_user.id
    comment.created_at = Time.now #HACK
    comment.save!
    # TODO : send mail
    if APP_CONFIG['use_mail']
      # followers = current_user.friends_of
      # followers.each do |follower|
      #   UserMailer.new_suda(follower, current_user, suda.message).deliver
      # end
    end
    result = {'code'=>'success','id'=>comment_id}
    render :text => ActiveSupport::JSON.encode(result)
  end
  
  def delete_via_ajax
    comment_id = params[:id]
    comment = Comment.find_by_id(comment_id)
    if comment.user_id != current_user.id
      result = {'code'=>'error','msg'=>"You can not delete other's comment."}
    elsif suda.created_at < 1.days.ago.to_date
      result = {'code'=>'error','msg'=>"You can not delete comment after 1 day."}
    else 
      comment.destroy
      result = {'code'=>'success','id'=>suda_id}
    end
    render :text => ActiveSupport::JSON.encode(result)
  end

end
