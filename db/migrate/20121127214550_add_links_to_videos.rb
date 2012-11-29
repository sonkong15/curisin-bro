class AddLinksToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :link, :string
  end
end
