class Menulist < ActiveRecord::Base
  def self.gettrans kname,id
    menu=self.find_by(kname: kname)
    if nil==menu
      menulist=self.new(:kname => kname,
        :ename => kname,
        :ername => kname,
        :jnamea => kname,
        :cname => kname,
        :cnameb => kname,
        :aname => kname,
        :spanish => kname,
        :germany => kname,
        :italia => kname,
        :portugal => kname,
        :french => kname)
        menulist.save()
      return [kname, menulist.updated_at.to_i]
    else
      word=menu[{
          0 => 'ename',
          1 => 'jnamea',
          2 => 'cname',
          3 => 'cnameb',
          4 => 'kname',
          5 => 'aname',
          6 => 'spanish',
          7 => 'germany',
          8 => 'italia',
          9 => 'portugal',
          10 => 'french'
        }[id]]
      if word!=""&&word!=nil
        return [word, menu.updated_at.to_i]
      else
        return [kname,menu.updated_at.to_i]
      end
    end
  end
  
end
