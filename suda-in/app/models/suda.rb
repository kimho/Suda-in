class Suda < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :message, :created_at
  has_many :comments, :dependent => :destroy
  
  def self.all_sudas(page)
    offset = ((page.to_i-1)*20)
    if offset < 0
      offset = 0
    end
    limit = 20
    # if page.to_i == 1
    #   limit = 21 # for more button check
    # end
    Suda.find(:all, :order => "created_at desc", :limit => limit, :offset => offset)
  end
  
  def self.find_by_search_query(q, page)
    offset = ((page.to_i-1)*20)
    if offset < 0
      offset = 0
    end
    limit = 20
    # if page.to_i == 1
    #   limit = 21 # for more button check
    # end
    Suda.find(:all, :conditions=>["message like ?", "%#{q}%"], :order => "created_at desc", :limit => limit, :offset => offset)
  end
  
  def comments_of
    Comment.find(:all, :conditions => ["suda_id = ?", self.id]).map{|s|s.comment}
  end
  
end
