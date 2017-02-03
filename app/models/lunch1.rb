require 'Top'
require 'Stringfy'

class Lunch1 < ActiveRecord::Base
  include Top
  include Stringfy
  
  def self.getname
    return 'Lunch 1'
  end
end
