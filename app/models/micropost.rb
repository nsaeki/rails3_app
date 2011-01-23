# == Schema Information
# Schema version: 20110123171340
#
# Table name: microposts
#
#  id          :integer         not null, primary key
#  content     :string(255)
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  in_reply_to :integer
#

class Micropost < ActiveRecord::Base
  attr_accessible :content
  
  belongs_to :user
  belongs_to :reply_to, :class_name => "User", :foreign_key => "id"

  validates :content, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true

  before_save :extract_reply

  default_scope :order => 'microposts.created_at DESC'

  scope :from_users_followed_by, lambda { |user| followed_by(user) }
  scope :including_replies, lambda { |user| replies(user) }

  private

  # Return an SQL condition for users followed by the given user.
  # We include the user's own id as well.
  def self.followed_by(user)
    followed_ids = %(SELECT followed_id FROM relationships
                    WHERE follower_id = :user_id)
    where("user_id IN (#{followed_ids}) OR user_id = :user_id",
      {:user_id => user})
  end
  
  def self.replies(user)
    where("in_reply_to = :user_id", {:user_id => user})
  end
  
  def extract_reply
    self.content =~ /\A@([\w\-.]+)/
    replied_user = User.find_by_login_name($1)
    self.in_reply_to = replied_user.id if replied_user
  end
end
