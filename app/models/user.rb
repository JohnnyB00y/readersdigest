class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	
  devise :omniauthable, :omniauth_providers => [:facebook]

  has_many :comments
  has_many :links, dependent: :destroy
  
  def owns_link?(link)
     self == link.user
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
