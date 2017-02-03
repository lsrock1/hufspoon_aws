require 'Top'
require 'Stringfy'
class Dinner < ActiveRecord::Base
  include Top
  include Stringfy
  
  def self.getname
    return 'dinner'
  end
end
