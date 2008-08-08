class Question < ActiveRecord::Base
  belongs_to :event
  
  has_many :votes
    
  validates_presence_of :question
  validates_uniqueness_of :question
  
end
