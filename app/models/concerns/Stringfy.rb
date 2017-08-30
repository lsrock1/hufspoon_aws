require 'active_support/concern'

module Stringfy
  extend ActiveSupport::Concern
  
  module ClassMethods

    def make_list day, id
      menu_data = self.find_by(date: day)
      innum = 0
      ingre = []
      
      unless menu_data == nil
        menu_list = []
        kcal = nil
        price = nil
        main = nil
        update = menu_data.updated_at.to_i
        menu_data = menu_data.menu.split("$")
        if self.getname != "Snack"
          time = menu_data.shift
          menu_data.each do |l|
            if l.index(":") || l.index(";")
              menulist = makeingre(l, id)
              ingre.concat([menulist[0]])
              update = update + menulist[1]
            elsif l[-1] == "l"
              kcal = l
            elsif l[-1] == "원"
              price = l[0..-2] + " won"
            else
              xfood = l.strip
              if xfood.index("&") || xfood.index("/") || xfood.index("-") || xfood.index("*")
                menulist = spliter(xfood, id)
                menu_list.push(menulist[0])
                update = update + menulist[1]
                if innum == 0
                  main = extract(xfood)
                end
              else
                menulist = Menulist.gettrans(xfood, id)
                menu_list.push(menulist[0])
                update = update + menulist[1]
                if innum == 0
                  main = Menulist.find_by(kname: xfood)
                end
              end
            end
            innum = 1 + innum
          end
        else
          time = "09:00~18:40"
          menu_data.each do |s|
            if s.index("(")
              s.sub!("원", " won").sub!("-브라질산", "")
              sfirst = s.index("(") - 1
              food = s[0..sfirst]
              food.split("/").each do |f|
                temp = Menulist.gettrans(f, id)
                update = update + temp[1]
                menu_list.push(temp[0] + " " + s[sfirst + 1 .. -1])
              end
            end
          end
        end
      end
      return {
        name: self.getname,
        time: time,
        kcal: kcal,
        price: price,
        ingre: ingre.uniq,
        menu: menu_list,
        main: main,
        update: update,
        id: id
      }
    end
    
    #재료 리스트를 반환
    def makeingre string, tid
      string = string.strip()
      mark = string.index(";") ? ";" : ":"
      ingre = string.split(mark).first
      return Menulist.gettrans(ingre, tid)
    end
    
    #특수문자로 엮인 메뉴를 각각 번역해서 다시 특수문자로 엮음
    def spliter xfood, tid
      ["&", "/", "-", "*"].each do |word|
        if xfood.index(word)
          result = xfood.split(word).map{|item| Menulist.gettrans(item, tid)}
          @result_string = result.map{|item| item[0]}.join(word)
          @result_update = result.map{|item| item[1]}.inject(0, :+)
        end
      end
      return [@result_string, @result_update]
    end
    
    #특수문자로 엮인 메인 메뉴에서 메인 요리만 뽑아냄
    def extract xfood
      if xfood.index("&")
        divide = xfood.split("&")
      elsif xfood.index("/")
        divide = xfood.split("/")
      else
        divide = xfood.split("-")
      end
      result = Menulist.find_by(kname: divide[0])
      return result
    end
    
  end
end