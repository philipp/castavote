class Question < ActiveRecord::Base
  belongs_to :event
  
  has_many :answers
      
  validates_presence_of :question
  validates_uniqueness_of :question
  
  def answer_attributes=(answer_attributes)
    answer_attributes.each do |attributes|
      answers.build(attributes)
    end
  end
end
