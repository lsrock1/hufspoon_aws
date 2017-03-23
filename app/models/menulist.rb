require "Getlist"
class Menulist < ActiveRecord::Base
  include Getlist
  def self.gettrans kname,id
    menu = self.find_by(kname: kname)
    if nil == menu
      menulist=self.new(
        kname: kname,
        ename: kname,
        ername: kname,
        jnamea: kname,
        cname: kname,
        cnameb: kname,
        aname: kname,
        spanish: kname,
        germany: kname,
        italia: kname,
        portugal: kname,
        french: kname,
        esperanto: kname)
        menulist.save()
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
