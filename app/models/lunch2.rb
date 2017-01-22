require 'top'
class Lunch2 < ActiveRecord::Base
  include Top
  def self.getname
    return 'Lunch 2'
  end
end
