class Event < ActiveRecord::Base
  belongs_to :user
	has_many :eventTags
	has_many :tags, through: :eventTags

  validates :user_id, :title, :description, :datetime, :city, :state, :zip, :location,
  	:presence => true
  validates :zip, length: { is: 5 }, numericality: { only_integer: true }

  def created_by?(user)
  	return true if self.user == user
  	return false
  end

end
