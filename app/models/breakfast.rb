require 'top'
class Breakfast < ActiveRecord::Base
  include Top
  
  def self.getname
    return 'Breakfast'
  end
end
