require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login,    :case_sensitive => false
  validates_format_of       :login,    :with => RE_LOGIN_OK, :message => MSG_LOGIN_BAD

  validates_format_of       :name,     :with => RE_NAME_OK,  :message => MSG_NAME_BAD, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_format_of       :email,    :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD

  has_many :profiles
  has_many :companies, :through => :profiles
  

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation



  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def add_to_preallowed
    self.preallowed_id = find_or_create_preallowed_id
    self.save
  end

  #this methods will try to find a subject in preallowed by login, or will create a new one, will return a preallowed_id or nil
  def find_or_create_preallowed_id
    # first lets see if such seubject already eixst to avoid dups
    preallowed_id = Client.find(CLIENT_ID).get(:subject_id_from_name, :subject_name => login)
        
    if preallowed_id != nil and preallowed_id != "0"
      return preallowed_id
    end
    
    #otherwise create a new one
    subject = Subject.create(:name => self.login)
    return subject.id
  end

  def is_user_in_role(role_id)
    subject = Subject.find(self.preallowed_id)
    res = subject.get(:is_subject_in_role, :role_id => role_id)
    
    if res == "1"
      true
    else
      false
    end
  end

  # return true in case of success, false otherwise
  def add_user_to_role(role_id)
    # subject = Subject.find(preallowed_id)
    role = Role.find(role_id)

    # put :add_subject, :id => role.id, :subject_id => @subject.id, :client_id => @subject.client.id
    res = role.put(:add_subject, :id => role.id, :subject_id => preallowed_id, :client_id => CLIENT_ID)

    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      logger.debug "successfully added preallowed_user to role"
      return true
    else
      logger.error "error adding preallowed_user to role"        
      return false
    end
  end

  def has_access_to_resource?(resource_string)      
      subject = Subject.find(self.preallowed_id)
      
      res = subject.get(:has_access, :resource => resource_string)

      if res == "1"
        true
      else
        false
      end
  end

  def can_manage_company?(company)
    has_access_to_resource?("/companies/" + company.id.to_s)      
  end

  def promote_to_admin(company)
    @role = Role.admin_role(company)
    @role.add_to_subject(Subject.find(self.preallowed_id))      
  end

  def revoke_admin(company)
    @role = Role.admin_role(company)    
    @role.remove_from_subject(Subject.find(self.preallowed_id))      
  end

  def forgot_password
    @forgotten_password = true
    self.make_password_reset_code
  end
  # same as make_activation_code
  def make_password_reset_code
    self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end

  def reset_password
    # First update the password_reset_code before setting the 
    # reset_password flag to avoid duplicate email notifications.
    update_attributes(:password_reset_code => nil)
    @reset_password = true
  end  


  #used in user_observer
  def recently_forgot_password?
    @forgotten_password
  end
  
  def recently_reset_password?
    @reset_password
  end
  
  def self.find_for_forget(email)
    find :first, :conditions => ['email = ? and activated_at IS NOT NULL', email]
  end

  protected
    


end
