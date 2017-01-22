require 'top'
class Dinner < ActiveRecord::Base
  include Top
  def self.getname
    return 'dinner'
  end
end
