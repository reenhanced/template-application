class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :confirmable, :lockable,
         :trackable, :timeoutable, :validatable, :token_authenticatable,
         :omniauthable

  field :first_name
  field :last_name
  field :email

  validates_uniqueness_of :email, :case_sensitive => false

  def self.find_by_email(email)
    where(:email => email).first
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    debugger
    data = access_token['extra']['user_hash']
    if user = User.find_by_email(data["email"])
      user
    else # Create a user with a stub password. 
      User.new(:email => data["email"], :password => Devise.friendly_token[0,20]) 
    end
  end
end

