class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	

  has_many :comments
  has_many :links, dependent: :destroy
  
  def owns_link?(link)
     self == link.user
  end

  def owns_comment?(comment)
  	self == comment.user
  end

  
end
