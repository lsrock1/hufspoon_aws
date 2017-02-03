require 'Top'
require 'Stringfy'

class Lunch2 < ActiveRecord::Base
  include Top
  include Stringfy
  
  def self.getname
    return 'Lunch 2'
  end
end
