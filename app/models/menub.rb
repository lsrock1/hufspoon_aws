require 'Stringfy'

class Menub < ActiveRecord::Base
  include Stringfy
  
  def self.getname
    return 'Menu B'
  end
end
