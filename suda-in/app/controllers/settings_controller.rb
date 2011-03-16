class SettingsController < ApplicationController
  @@directory = "#{RAILS_ROOT}/public/emblems"
  
  def upload_profile_image(user)
    unless user['profile_image_uploaded_data']
      return false
    end
    extension = File.extname(user['profile_image_uploaded_data'].original_filename)
    extension = extension.downcase
    unless extension=='.jpg' || extension=='.png' || extension=='.gif'
      flash[:error] = "Only jpg,png,gif file can be used for profile picture."
      return false
    end
    helper = Object.new.extend(ActionView::Helpers::NumberHelper)
    filesize = user['profile_image_uploaded_data'].size
    if filesize > 1024 * 1000 * 5
      flash[:error] = "(#{helper.number_to_human_size(filesize)}) File size should be less than 5 KB."
      return false
    end
    filename = current_user.username
    name = filename + extension
    # create the file path
    path = File.join(@@directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(user['profile_image_uploaded_data'].read) }
    User.find_by_id(current_user.id).update_attribute(:picture, name)
  end
  
  def delete_profile_image(user)
    del_file = File.join(@@directory, current_user.username + ".jpg")
    File.delete(del_file) if File.exist?(del_file)
    del_file = File.join(@@directory, current_user.username + ".png")
    File.delete(del_file) if File.exist?(del_file)
    del_file = File.join(@@directory, current_user.username + ".gif")
    File.delete(del_file) if File.exist?(del_file)
    flash[:notice] = "Uploaded image was deleted. You are using Gravatar"
  end
  
  def update_settings
    if params[:del_emblem]=="y"
      self.delete_profile_image(params[:user])
    else
      self.upload_profile_image(params[:user])
    end
    redirect_to settings_path
  end

end
