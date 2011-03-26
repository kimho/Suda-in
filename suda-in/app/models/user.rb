require 'net/ldap'

class User < ActiveRecord::Base
  include Gravtastic
  is_gravtastic :size => 50
  
  # new columns need to be added here to be writable through mass assignment
  attr_accessible :username, :email, :nickname, :password, :password_confirmation, :agent
  
  attr_accessor :password
  before_save :prepare_password
  before_update :prepare_password

  validates_presence_of :username
  validates_uniqueness_of :username, :email, :allow_blank => true
  validates_format_of :username, :with => /^[-\w\_@]+$/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@"
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 4, :allow_blank => true
  validates_exclusion_of :username, :in => %w( admin supersuer following follower followers signup ), :message => "is not a usable user name"

  has_many :sudas, :dependent => :destroy
  has_many :friendships
  has_many :friends, :through => :friendships


  def friends_of
    Friendship.find(:all, :conditions => ["friend_id = ?", self.id]).map{|f|f.user}
  end
  
  def add_friend(friend)
    friendship = friendships.build(:friend_id => friend.id)
    if !friendship.save
      logger.debug "User '#{friend.email}' already exists in the user's friendship list."
    end
  end

  def remove_friend(friend)
    friendship = Friendship.find(:first, :conditions => ["user_id = ? and friend_id = ?", self.id, friend.id])
    if friendship
      friendship.destroy
    end
  end  
  
  def is_friend?(friend)
    return self.friends.include? friend
  end
  
  def our_sudas(page)
    offset = ((page.to_i-1)*20)
    if offset < 0
      offset = 0
    end
    limit = 20
    Suda.find(:all, :conditions => ["user_id in (?) ", friends.map(&:id).push(self.id)], :order => "created_at desc", :limit => limit, :offset => offset)
  end
  
  def my_sudas(page)
    offset = ((page.to_i-1)*20)
    limit = 20
    Suda.find(:all, :conditions => ["user_id = ? ", self.id], :order => "created_at desc", :limit => limit, :offset => offset)
  end
    
  def self.authenticate(login, password)
    login = login.downcase
    if APP_CONFIG['use_ldap']
      return self.ldap_auth(login, password)
    else
      return self.authenticate_db(login, password)
    end
  end
  
  def self.ldap_auth(login, password)
    require 'ping'
    
    username = login
    ldap_email = login + "@" + APP_CONFIG['ldap_domain']

    if (password.empty?) then
        password = 'empty'
    end
    unless Ping.pingecho(APP_CONFIG['ldap_host'], 3)
      return self.authenticate_db(login, password)
    end
    ldap = Net::LDAP.new(:host => APP_CONFIG['ldap_host'], :base => APP_CONFIG['ldap_base'])
    ldap.auth(ldap_email, password)
    # case ldap.bind
    # when Net::LDAP::LdapError
    #   return self.authenticate_db(login, password)
    # end
    if ldap.bind
      filter = Net::LDAP::Filter.eq('samaccountname', username)
      nickname ='anonymous'
      email = ''
      attrs = ["samaccountname","mail","department","displayname","telephonenumber"];
      ldap.search(:base => APP_CONFIG['ldap_base'], :filter => filter, :auth => {:method => :simple, :username => APP_CONFIG['ldap_username'] + "@" + APP_CONFIG['ldap_domain'], :password => APP_CONFIG['ldap_password']}, :attributes => attrs, :return_result => true) do |entry|
        entry.displayname.each {|name| nickname = name}
        entry.mail.each {|mail| email = mail}
      end

      user = find_by_username(username)
      user_info = {"username" => username, "email" => email, "nickname" => nickname, "password"=>password}
      if user
        # reset user info with ldap info
        User.update(user.id, user_info)
      else
        # signup user to db
        new_user = User.new(user_info)
        if new_user.save
          if APP_CONFIG['use_mail']
            # send welcome mail
            new_user = find_by_username(username)
            UserMailer.registration_confirmation(new_user).deliver
          end
        end
      end
      
      # return username in DB
      user = find_by_username(username)
      if user
        return user
      else
        return false
      end
    else
      # if ldap login fail, change password and inactivate the user
      user = find_by_username(username)
      passwords = {"password_hash"=>SecureRandom.hex(10), "password_salt"=>SecureRandom.hex(10)}
      User.update_all(passwords, {:id => user.id})
      return false
    end
  end

  def self.authenticate_db(login, password)
    user = find_by_username(login)
    return user if user && user.matching_password?(password)
  end

  def matching_password?(pass)
    self.password_hash == encrypt_password(pass)
  end

  private

  def prepare_password
    unless password.blank?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = encrypt_password(password)
    end
  end

  def encrypt_password(pass)
    BCrypt::Engine.hash_secret(pass, password_salt)
  end
end
