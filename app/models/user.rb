class User < ApplicationRecord
  include AlgoliaSearch
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :follower_relationships, foreign_key: :following_id, class_name: 'Follow'
  has_many :followers, through: :follower_relationships, source: :follower
  has_many :following_relationships, foreign_key: :follower_id, class_name: 'Follow'
  has_many :following, through: :following_relationships, source: :following
	
  devise :omniauthable, :omniauth_providers => [:facebook]
  has_many :votes
  has_many :comments
  has_many :links, dependent: :destroy
  has_many :bookmarks
  
  def owns_link?(link)
     self == link.user
  end

  algoliasearch do
    attribute :name
  end

  def follow(user_id)
    following_relationships.create(following_id: user_id)
  end

  def unfollow(user_id)
    following_relationships.find_by(following_id: user_id).destroy
  end

  def follower_count
    followers.count
  end

  def name
    "#{first_name} #{last_name}"
  end

  def bookmarks?(link)
    link.bookmarks.where(user_id: id).any?
  end

  def upvote(link)
  votes.create(upvote: 1, link: link)
  end

  def upvoted?(link)
    votes.exists?(upvote: 1, link: link)
  end

  def remove_vote(link)
    votes.find_by(link: link).destroy
  end

  def owns_comment?(comment)
  	self == comment.user
  end

  def self.from_omniauth(auth)
  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    user.email = auth.info.email
    user.image = auth.info.image
    user.first_name = auth.info.first_name
    user.last_name = auth.info.last_name
    user.provider = auth.provider
    user.uid = auth.uid
    user.password = Devise.friendly_token[0,20]
  end
end
  
end
