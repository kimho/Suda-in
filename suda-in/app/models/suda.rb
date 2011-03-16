class Suda < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :message, :created_at
  
  def self.all_sudas(page)
    offset = ((page.to_i-1)*20)
    limit = 20
    # if page.to_i == 1
    #   limit = 21 # for more button check
    # end
    Suda.find(:all, :order => "created_at desc", :limit => limit, :offset => offset)
  end
  
  def self.find_by_search_query(q, page)
    offset = ((page.to_i-1)*20)
    limit = 20
    # if page.to_i == 1
    #   limit = 21 # for more button check
    # end
    Suda.find(:all, :conditions=>["message like ?", "%#{q}%"], :order => "created_at desc", :limit => limit, :offset => offset)
  end
  
end
