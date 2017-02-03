require 'Stringfy'

class Flunch < ActiveRecord::Base
  include Stringfy
  
  def self.getname
    return 'Lunch'
  end
end
