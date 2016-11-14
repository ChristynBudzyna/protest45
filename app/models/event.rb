class Event < ActiveRecord::Base
  belongs_to :user
	has_many :eventTags
	has_many :tags, through: :eventTags

  # validates :title, :presence => true
  # validates :description, :presence => true
  # validates :date, :presence => true
  # validates :time, :presence => true
end
