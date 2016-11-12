class User < ActiveRecord::Base
  has_secure_password
  has_many :events

  validates :email, :presence => true
  validates :password, :presence => true
end
