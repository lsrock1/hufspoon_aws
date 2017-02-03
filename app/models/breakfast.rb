require 'Top'
require 'Stringfy'
class Breakfast < ActiveRecord::Base
  include Top
  include Stringfy
  
  def self.getname
    return 'Breakfast'
  end
end
