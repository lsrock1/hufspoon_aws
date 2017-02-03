require 'Stringfy'

class Snack < ActiveRecord::Base
  include Stringfy
  def self.getname
    return 'Snack'
  end
end
