class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string     :title
      t.string     :location
      t.string     :address
      t.string     :description
      t.string     :city
      t.datetime   :datetime
      t.string     :facebook_url
      t.string     :other_url
      t.boolean    :approved?, :default => false
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
