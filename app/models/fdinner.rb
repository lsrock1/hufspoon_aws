require 'Stringfy'

class Fdinner < ActiveRecord::Base
  include Stringfy
  
  def self.getname
    return 'Dinner'
  end
end
