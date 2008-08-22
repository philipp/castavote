require 'digest/sha1'
class Company < ActiveRecord::Base
  has_many :events
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def before_create 
      self.joining_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )      
  end
  
end
