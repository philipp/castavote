require 'digest/sha1'
class Company < ActiveRecord::Base
  has_many :events
  
  has_many :profiles
  has_many :users, :through => :profiles
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def before_create 
      generate_new_joining_code
  end
  
  def generate_new_joining_code
    self.joining_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )      
  end
end
