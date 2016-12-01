class AddPictureUrlToEvents < ActiveRecord::Migration
  def change
    add_column :events, :picture_url, :string
  end
end
