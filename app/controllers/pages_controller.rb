class PagesController < ApplicationController

def tips
end

def admin
  @events = Event.where(approved: false)
end

end
