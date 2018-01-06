class Link < ApplicationRecord
  acts_as_taggable_on :tags
  belongs_to :user
  has_many :comments, :dependent => :destroy
  validates_length_of :title, :in => 3..150
  validates_length_of :description, :maximum => (64 * 1024)
  validates_presence_of :user_id
   attr_accessor :already_posted_link
	validates :title,
	            presence: true,
	            uniqueness: { case_sensitive: false }
	            
	validates :url,
	          format: { with: %r{\Ahttps?://} },
	          allow_blank: false
	validate do
	    if self.url.present?
	      check_already_posted
	      # URI.parse is not very lenient, so we can't use it
	      unless self.url.match(/\Ahttps?:\/\/([^\.]+\.)+[a-z]+(\/|\z)/i)
	        errors.add(:url, "is not valid")
	      end
	    elsif self.description.to_s.strip == ""
	      errors.add(:description, "must contain text if no URL posted")
	    end

	    if !errors.any? && self.url.blank?
	      self.user_is_author = true
	    end

	  end


 def check_already_posted
    return unless self.url.present? && self.new_record?

    self.already_posted_link = Link.find_similar_by_url(self.url)
    if self.already_posted_link&.is_recent?
      errors.add(:url, "has already been submitted within the past " <<
        "#{RECENT_DAYS} days")
    end
  end

  # returns a link or nil
  def self.find_similar_by_url(url)
    urls = [ url.to_s ]
    urls2 = [ url.to_s ]

    # https
    urls.each do |u|
      urls2.push u.gsub(/^http:\/\//i, "https://")
      urls2.push u.gsub(/^https:\/\//i, "http://")
    end
    urls = urls2.clone

    # trailing slash
    urls.each do |u|
      urls2.push u.gsub(/\/+\z/, "")
      urls2.push (u + "/")
    end
    urls = urls2.clone

    # www prefix
    urls.each do |u|
      urls2.push u.gsub(/^(https?:\/\/)www\d*\./i) {|_| $1 }
      urls2.push u.gsub(/^(https?:\/\/)/i) {|_| "#{$1}www." }
    end
    urls = urls2.clone

    # if a previous submission was moderated, return it to block it from being
    # submitted again
 	Link
      .where(:url => urls)
      .order("id DESC").first
  end

  def is_recent?
    self.created_at >= RECENT_DAYS.days.ago
  end

	RECENT_DAYS = 30

end
