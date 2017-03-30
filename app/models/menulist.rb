require "Getlist"
class Menulist < ActiveRecord::Base
  include Getlist
  def self.gettrans kname,id
    menu = self.find_by(kname: kname)
    if nil == menu
      keys = Menulist.column_names
      keys.delete("id")
      keys.delete("updated_at")
      keys.delete("created_at")
      keys.delete("u_like")
      keys.delete("u_picture")
      menulist = self.new(
        keys.zip([kname]*keys.length))
        .save()
      return [kname, menulist.updated_at.to_i]
    else
      word = menu[Menulist.new.languageHash[id][1]]
      if word != "" && word != nil
        return [word, menu.updated_at.to_i]
      else
        return [kname,menu.updated_at.to_i]
      end
    end
  end
  
end
