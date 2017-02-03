require 'Stringfy'

class Menua < ActiveRecord::Base
  include Stringfy
  
  def self.getname
    return 'Menu A'
  end
end
