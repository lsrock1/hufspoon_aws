require 'active_support/concern'

module Top
  extend ActiveSupport::Concern
  
  module ClassMethods

    def make_hash(string_hash)
      self.all.each do |daily|
        daily.menu
        .sub(/-|\/|&/, "$")
        .split("$")
        .map{|menu| string_hash[menu] += 1 if !menu.index(":") && menu[-1]!="l" && menu[-1]!="원"}
      end
    end
  end
end