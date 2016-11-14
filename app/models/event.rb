class Event < ActiveRecord::Base
  belongs_to :user
  has_many :tags


  validates :title, :presence => true
  validates :description, :presence => true
  validates :date, :presence => true
  validates :time, :presence => true
end
