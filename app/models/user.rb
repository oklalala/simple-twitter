class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader

  #reply
  has_many :tweets, dependent: :destroy
  has_many :replies, dependent: :destroy

  #Like unlike
  has_many :likes, dependent: :destroy
  has_many :liked_tweets, through: :likes, source: :tweet

  #Following Follower
  has_many :followships, dependent: :destroy
  has_many :followings, through: :followships
  
  has_many :inverse_followships, class_name: "Followship", foreign_key: "following_id"
  has_many :followers, through: :inverse_followships, source: :user

  # 需要 app/views/devise 裡找到樣板，加上 name 屬性
  # 並參考 Devise 文件自訂表單後通過 Strong Parameters 的方法
  # 加上驗證 name 不能重覆 (關鍵字提示: uniqueness)
  validates_presence_of :name

  # 使用者的名稱不能重覆，若有重覆會跳出錯誤
  validates :name, uniqueness: { message: " has already been taken."}

  def admin?
    self.role == "admin"
  end

  def following?(user)
    self.followings.include?(user)
  end

  def self.recent_following
    Followship.select('following_id, count(keyword_id) as frequency').
      order('frequency desc').
      group('keyword_id').
      take(20).
      map(&:keyword)
  end

  def tweet_reply_count
    self.tweets.count + self.replies.count
  end
  #<%= @user.tweet_reply_count %>

end
