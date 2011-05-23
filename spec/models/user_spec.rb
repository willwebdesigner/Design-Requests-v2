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

require 'spec_helper'

describe User do
  before(:each) do
      @attr = { 
        :name => "Example User", 
        :email => "user@example.com", 
        :password => "foobar",
        :password_confirmation => "foobar"
      }
    end

    it "should create a new instance given valid attributes" do
      User.create!(@attr)
    end

    it "should require a name" do
        no_name_user = User.new(@attr.merge(:name => ""))
        no_name_user.should_not be_valid
    end
    
    it "should require an email address" do
        no_email_user = User.new(@attr.merge(:email => ""))
        no_email_user.should_not be_valid
    end
    
    it "should reject names that are too long" do
        long_name = "a" * 51
        long_name_user = User.new(@attr.merge(:name => long_name))
        long_name_user.should_not be_valid
    end
    
    it "should reject duplicate email addresses" do
        # Put a user with given email address into the database.
        User.create!(@attr)
        user_with_duplicate_email = User.new(@attr)
        user_with_duplicate_email.should_not be_valid
    end
    
    it "should reject email addresses identical up to case" do
        upcased_email = @attr[:email].upcase
        User.create!(@attr.merge(:email => upcased_email))
        user_with_duplicate_email = User.new(@attr)
        user_with_duplicate_email.should_not be_valid
    end
    
    
    
    #password validations
    describe "password validations" do     
      it "Should require a password" do
        User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
      end
      
      it "should require a matching password confirmation" do
        User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
      end

      it "should reject short passwords" do
        short = "a" * 5
        hash = @attr.merge(:password => short, :password_confirmation => short)
        User.new(hash).should_not be_valid
      end

      it "should reject long passwords" do
        long = "a" * 41
        hash = @attr.merge(:password => long, :password_confirmation => long)
        User.new(hash).should_not be_valid
      end          
    end
    
    
    
    describe "password encryption" do
      before(:each) do
        @user = User.create!(@attr)
      end

      it "should have an encrypted password attribute" do
        @user.should respond_to(:encrypted_password)
      end   
        
      it "should set the encrypted password" do
        @user.encrypted_password.should_not be_blank
      end
      
      describe "has_password? method" do
        it "should be true if the passwords match" do
          @user.has_password?(@attr[:password]).should be_true
        end    

        it "should be false if the passwords don't match" do
          @user.has_password?("invalid").should be_false
        end 
      end
      
      describe "authenticate method" do
        it "should return nil on a password/username mismatch" do
          wrong_password_user = User.authenticate(@attr[:email], "WrongPass")
          wrong_password_user.should be_nil
        end
        
        it "should return nil for a non existent user" do
          nonexistent_user = User.authenticate("foo@bar.com", @attr[:password])
          nonexistent_user.should be_nil
        end
        
        it "should return the user on email/password match" do
          matching_user = User.authenticate(@attr[:email], @attr[:password])
          matching_user.should == @user
        end
      end
      
    end   
end



