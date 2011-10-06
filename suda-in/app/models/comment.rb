class Comment < ActiveRecord::Base
  belongs_to :suda
  belongs_to :user
  validates_presence_of :suda_id, :user_id, :message
end
