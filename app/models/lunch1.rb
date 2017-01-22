require 'top'
class Lunch1 < ActiveRecord::Base
  include Top
  def self.getname
    return 'Lunch 1'
  end
end
