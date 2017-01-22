require 'top'
class Lunchnoodle < ActiveRecord::Base
  include Top
  def self.getname
    return 'Lunch Noodles'
  end
end
