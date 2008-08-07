class Event < ActiveRecord::Base
  belongs_to :company
    
  validates_presence_of :name
  validates_presence_of :date
  validates_uniqueness_of :name
  
end
