require 'Top'
require 'Stringfy'

class Lunchnoodle < ActiveRecord::Base
  include Top
  include Stringfy
  
  def self.getname
    return 'Lunch Noodles'
  end
end
