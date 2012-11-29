class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :vimeo
      t.text :vimeo_html
      t.string :youtube
      t.text :youtube_html
      t.integer :user_id
      t.text :video_thumb
      t.string :title
      t.string :slug

      t.timestamps
    end
    add_index :videos, :slug, unique: true
  end
end
