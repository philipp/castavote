class Event < ActiveRecord::Base
  belongs_to :company

  has_many :questions
    
  validates_presence_of :name
  validates_uniqueness_of :name
  
end
