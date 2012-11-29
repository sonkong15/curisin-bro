class User < ActiveRecord::Base
	has_many :posts
  has_many :videos
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


   private 

  def self.find_or_create_from_oauth(auth_hash)
    provider = auth_hash["provider"]
    uid = auth_hash["uid"]
    case provider
      when 'facebook'
        if user = self.find_by_email(auth_hash["info"]["email"])
          user.update_user_from_facebook(auth_hash)
          return user
        elsif user = self.find_by_facebook_uid(uid)
          return user
        else
          return self.create_user_from_facebook(auth_hash)
        end
    end
  end
  def self.create_user_from_facebook(auth_hash)
    sign_in @user, :bypass => true
    self.create({
      :uid => auth_hash["uid"],
      :name => auth_hash["info"]["name"],
      :image => auth_hash["info"]["image"],
      :email => auth_hash["info"]["email"],
      location:auth.info.location,
      password:Devise.friendly_token[0,20]
      
    })
  end
  def update_user_from_facebook(auth_hash)
    sign_in @user, :bypass => true
    self.update_attributes({
      provider:auth.provider,
      :uid => auth_hash["uid"],
      :image => auth_hash["info"]["image"],
    })
  end

end





