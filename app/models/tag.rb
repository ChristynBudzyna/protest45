class Tag < ActiveRecord::Base
	has_many :eventTags
	has_many :events, through: :eventTags
end
