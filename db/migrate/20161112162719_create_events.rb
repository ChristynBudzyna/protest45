class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :user, index: true, foreign_key: true
      t.string     :title, null: false
      t.text       :description, null: false
      t.datetime   :datetime, null: false

      # Location information
      t.string     :address1, default: ""
      t.string     :address2, default: ""
      t.string     :city, null: false
      t.string     :state, null: false
      t.integer    :zip, null: false

      # Dropdown-selectable location category (i.e. New York, DC, San Francisco, Portland, etc)
      t.string     :location, null: false
      
      # Link to event off-site from Protest45 for more info/original source
      t.string     :url
      t.string     :event_source # i.e. dropdown selectable Facebook, Meetup, Craigslist, Other

      # for Admin users
      t.boolean    :approved?, :default => false

      t.timestamps null: false
    end
  end
end
