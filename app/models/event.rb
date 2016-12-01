require 'open-uri'
require 'JSON'
class Event < ActiveRecord::Base
  belongs_to :user
	has_many :event_tags
	has_many :tags, through: :event_tags

  validates :user_id, :title, :description, :datetime, :city, :state, :zip, :location,
  	:presence => true
  validates :zip, length: { is: 5 }, numericality: { only_integer: true }

  def created_by?(user)
  	return true if self.user == user
  	return false
  end

  def self.get_FB_picture_url( event_source, event_url )
    if event_source == 'Facebook'
      event_id = event_url.split( "/" )[-1]
      event_cover_obj = JSON.parse( open( "https://graph.facebook.com/v2.8/" + event_id + "?access_token=" + ENV['FB_ACCESS_TOKEN'] + "&fields=cover" ).read )

      return event_cover_obj['cover']['source']
    else
      return ""
    end
  end

end
