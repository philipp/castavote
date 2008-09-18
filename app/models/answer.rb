class Answer < ActiveRecord::Base
  has_many :votes

  @@convert = {
     "&" => "%26amp;",
     "<" => ".gt.",
     ">" => ".lt.",
     "'" => "%26apos;",
     '"' => "%26quot;"
  }

  def escaped_value
    result = self.value
    result.gsub(/[&<>'"]/) do | match |
      @@convert[match]
    end
 
    #result #.gsub(/['<>&?&#"]/) {|s| " " }        
    
  end
end
