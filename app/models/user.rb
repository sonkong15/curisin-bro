class User < ActiveRecord::Base
	has_many :posts
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :bio, :avatar, :admin

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
  
end
