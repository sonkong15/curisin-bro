class Video < ActiveRecord::Base
  attr_accessible :title, :vimeo, :youtube, :link, :desrition, :video_thumb, :tag_list
  belongs_to :user
  acts_as_taggable
  extend FriendlyId
  friendly_id :title, use: :slugged

  validates :title, presence: true

  	def facebook_thumb
  		self.facebook.gsub(/http:\/\/www\.dailymotion\.com.*\/video\/(.+)_*/) do
    	video_id = $1
    	self.video_thumb = %{http://www.dailymotion.com/thumbnail/video/#{video_id}}

    	end
  	end


 auto_html_for :facebook do
    html_escape
    image
    youtube(:width => 640, :height => 360)
    link :target => "_blank", :rel => "nofollow"
    simple_format
  end

  auto_html_for :youtube do
    html_escape
    image
    youtube(:width => 640, :height => 360)
    link :target => "_blank", :rel => "nofollow"
    simple_format
  end

  auto_html_for :vimeo do
    html_escape
    image
    vimeo(:width => 640, :height => 360)
    link :target => "_blank", :rel => "nofollow"
    simple_format
  end
	  AutoHtml.add_filter(:vimeo).with(:width => 440, :height => 248, :show_title => false, :show_byline => false, :show_portrait => false) do |text, options|
	  text.gsub(/https?:\/\/(www.)?vimeo\.com\/([A-Za-z0-9._%-]*)((\?|#)\S+)?/) do
	    vimeo_id = $2
	    width  = options[:width]
	    height = options[:height]
	    show_title      = "title=0"    unless options[:show_title]
	    show_byline     = "byline=0"   unless options[:show_byline]  
	    show_portrait   = "portrait=0" unless options[:show_portrait]
	    frameborder     = options[:frameborder] || 0
	    query_string_variables = [show_title, show_byline, show_portrait].compact.join("&")
	    query_string    = "?" + query_string_variables unless query_string_variables.empty?

	    %{<iframe src="//player.vimeo.com/video/#{vimeo_id}#{query_string}" width="#{width}" height="#{height}" frameborder="#{frameborder}"></iframe>}
	  end
	end

	AutoHtml.add_filter(:youtube).with(:width => 420, :height => 315, :frameborder => 0, :wmode => nil) do |text, options|
	  regex = /https?:\/\/(www.)?(youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/watch\?feature=player_embedded&v=)([A-Za-z0-9_-]*)(\&\S+)?(\S)*/
	  text.gsub(regex) do
	    youtube_id = $3
	    width = options[:width]
	    height = options[:height]
	    frameborder = options[:frameborder]
			wmode = options[:wmode]
			src = "//www.youtube.com/embed/#{youtube_id}?rel=0&showinfo=0&theme=light"
			src += "?wmode=#{wmode}" if wmode
	    %{<iframe width="#{width}" height="#{height}" src="#{src}" frameborder="#{frameborder}" allowfullscreen></iframe>}
	  end

	end
	AutoHtml.add_filter(:facebook).with(:width => 480, :height => 360) do | text, options|
		text.gsub(/^http(?:s?):\/\/www\.facebook\.com\/photo.php\?v=(\d+)/) do
			facebook_id = $1
			%{<object><param name="allowfullscreen" value="true"></param><param name="movie" value="https://www.facebook.com/v/#{facebook_id}"></param><embed src="https://www.facebook.com/v/#{facebook_id}" type="application/x-shockwave-flash" allowfullscreen="1"></embed></object>}
		end
	end

	def previous_video
  		self.class.first(:conditions => ["created_at  < ? ", created_at ], :order => "created_at desc")
	end

	def next_video
  		self.class.first(:conditions => ["created_at  > ? ", created_at ], :order => "created_at asc")
	end
end
