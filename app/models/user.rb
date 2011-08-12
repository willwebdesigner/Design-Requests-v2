# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password                                               # Virtual (in memory password attribute, not in db)
  attr_accessible :name, :email, :password, :password_confirmation      # These are the attributes available to the end user
  before_save :encrypt_password                                         # A call to the :encrypt_password method before the object gets saved to the db
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i # Variable for email format
  
  validates :name,  
            :presence => true, :length => { :maximum => 50 }
            
  validates :email, 
            :presence => true, :format => { :with => email_regex}, :uniqueness => true, :uniqueness => { :case_sensitive => false }
  
  # Automatically create the virtual attribute 'password_confirmation'.          
  validates :password,
            :presence => true, :confirmation => true, :length => { :within => 6..40 }
  
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end
  
  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  private
   
    def encrypt_password
      self.salt = make_salt if new_record?          # This gets stored in the db if it's a new record
      self.encrypted_password = encrypt(password)   # This gets stored in the db after running through the methods
    end
  
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end          
  
end

