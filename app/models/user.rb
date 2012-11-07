class User < ActiveRecord::Base
	has_many :posts
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :bio, :avatar, :admin, :image,
  :location, :provider, :uid, :facebook_link, :website_link

  has_attached_file :avatar, :styles =>{ :small => "150x150>"},
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/aws.yml",
    :path => ":id/:style.:extension",
    :hash_secret => ''

	before_save { |user| user.email = email.downcase }

	validates :name, presence: true, length: { maximum: 25 }
	validates :name, uniqueness: {case_sensitive: false}

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates_presence_of(:email)
	validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false}
	validates :password, presence: true, length: { minimum: 6 }, :on => :create
	validates :password_confirmation, presence: true, :on => :create
	validates :bio, length: {maximum: 1000}
	extend FriendlyId
		friendly_id :name
  
  	def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
  user = User.where(:provider => auth.provider, :uid => auth.uid).first
  unless user
    user = User.create(name:auth.extra.raw_info.name,
                         provider:auth.provider,
                         uid:auth.uid,
                         email:auth.info.email,
                         location:auth.info.location,
                         image:auth.info.image,
                         password:Devise.friendly_token[0,20]
                         )
  end
  user
	end
	def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
   		end
  	end
end





