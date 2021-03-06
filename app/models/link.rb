class Link < ApplicationRecord
  include AlgoliaSearch
  scope :hottest, -> { order(hot_score: :desc) }
  scope :newest, -> { order(created_at: :desc) }
  has_many :votes
  has_many :bookmarks
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

  algoliasearch do
    attribute :title, :description, :tags
  end

  def upvotes
    votes.sum(:upvote)
  end

  def popular_authors
    bestauthors = links.author.all.count(desc)
  end

  def calc_hot_score
  points = upvotes
  time_ago_in_hours = ((Time.now - created_at) / 3600).round
  score = hot_score(points, time_ago_in_hours)

  update_attributes(points: points, hot_score: score)
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

  def comment_count
    comments.length
  end

	RECENT_DAYS = 30

  # ----------------> HOT SCORE <-------------

  private

def hot_score(points, time_ago_in_hours, gravity = 1.8)
  # one is subtracted from available points because every link by default has one point 
  # There is no reason for picking 1.8 as gravity, just an arbitrary value
  (points - 1) / (time_ago_in_hours + 2) ** gravity
end


end
