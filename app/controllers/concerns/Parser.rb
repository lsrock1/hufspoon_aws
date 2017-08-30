require 'open-uri'

module Parser
  extend ActiveSupport::Concern
  
  def htmlToString info, menu
    menuString = info
    menu.each do |x|
      if x.text != ""
        string = x.text
        if string.index("(")
          substring = string[string.index("(")..string.index(")")]
          string.sub!(substring, "$" + substring[1...-1])
          put("주목목")
          put(string)
        end
        if string.index(",") && string[-1] != "원"
          string.gsub!(",", "$")
        end
        if string.index(":") && (string.index("/")||string.index("&")||string.index("-")||string.index("*"))
          string.gsub!(/[\/\*&-]/, "$")
        end
        menuString = menuString + "$" + string.strip
      end
    end
    return menuString
  end
  
  
  def parsing_func today
    mainadd = "https://webs.hufs.ac.kr/jsp/HUFS/cafeteria/viewWeek.jsp"
    resultadd = mainadd + "?startDt=" + today + "&endDt=" + today + "&caf_name=" + URI.encode("인문관식당") + "&caf_id=h101"
    doc = Nokogiri::HTML(open(resultadd, read_timeout: 10))
    humanity=doc.xpath("//html/body/form/table/tr")
    ###################인문관식당 파싱##########################
    
    resultadd = mainadd + "?startDt=" + today + "&endDt=" + today + "&caf_name=" + URI.encode("교수회관식당") + "&caf_id=h102"
    doc = Nokogiri::HTML(open(resultadd, read_timeout: 10))
    faculty=doc.xpath("//html/body/form/table/tr")
    ###################교수회관 파싱##############
    
    
    resultadd = mainadd + "?startDt=" + today + "&endDt=" + today + "&caf_name=" + URI.encode("스카이라운지") + "&caf_id=h103"
    doc = Nokogiri::HTML(open(resultadd, read_timeout: 10))
    sky = doc.xpath("//html/body/form/table/tr")
    ###############스카이라운지 파싱##############
    
    ##############인문관식당 파싱 자료 분류#############
    #snack
    if Snack.find_by(date: today)==nil
      snack=humanity.xpath("./td[@class='listStyle2']").text
      if snack!=""
        snack=snack.gsub!(" ","")
        snack=snack.split('*')[0...-1]
        snack_form=""
        snack.each do|s|
          if s.index("(")!=nil
            snack_form=snack_form+"$"+s.strip
          end
        end
        Snack.new(date: today,menu: snack_form).save
      end
    end
    
    humanity.each_with_index do |n,num|
      unless num==0 
      
        humanity_list=n.xpath("./td[@class='headerStyle']")
        
        if humanity_list.text[0..4]=="중식(1)"
          if Lunch1.find_by(date: today)==nil
            menuString=htmlToString(humanity_list.text[5..6]+":"+humanity_list.text[7..11]+":"+humanity_list.text[12..13], n.xpath("./td/table/tr/td"))
            Lunch1.new(date: today, menu: menuString).save
          end
        elsif humanity_list.text[0..4]=="중식(2)"
          if Lunch2.find_by(date: today)==nil
            menuString=htmlToString(humanity_list.text[5..6]+":"+humanity_list.text[7..11]+":"+humanity_list.text[12..13], n.xpath("./td/table/tr/td"))
            Lunch2.new(date: today, menu: menuString).save
          end
        elsif humanity_list.text[0..4]=="중식(면)"
          if Lunchnoodle.find_by(date: today)==nil
            menuString=htmlToString(humanity_list.text[5..6]+":"+humanity_list.text[7..11]+":"+humanity_list.text[12..13], n.xpath("./td/table/tr/td"))
            Lunchnoodle.new(date: today, menu: menuString).save
          end
        elsif humanity_list.text[0..1]=="조식"
          if Breakfast.find_by(date: today)==nil
            menuString=htmlToString(humanity_list.text[2..3]+":"+humanity_list.text[4..8]+":"+humanity_list.text[9..10], n.xpath("./td/table/tr/td"))
            Breakfast.new(date: today, menu: menuString).save
          end
        elsif humanity_list.text[0..1]=="석식"
          if Dinner.find_by(date: today)==nil
            menuString=htmlToString(humanity_list.text[2..3]+":"+humanity_list.text[4..8]+":"+humanity_list.text[9..10], n.xpath("./td/table/tr/td"))
            Dinner.new(date: today, menu: menuString).save
          end
        end
      end
    end
    ################인문관식당 파싱 분석 끝####################
    
    ###################교수회관식당 파싱 분석 시작#############
    faculty.each_with_index do |n, num|
      unless num==0 || num==3
      
        faculty_list=n.xpath("./td[@class='headerStyle']")
        
        if faculty_list.text[0..1]=="중식"
          if Flunch.find_by(date: today)==nil
            menuString=htmlToString(faculty_list.text[2..3]+":"+faculty_list.text[4..8]+":"+faculty_list.text[9..10], n.xpath("./td/table/tr/td"))
            Flunch.new(date: today, menu: menuString).save
          end
        elsif faculty_list.text.to_s[0..1] == "석식"
          if Fdinner.find_by(date: today) == nil
            menuString = htmlToString(faculty_list.text[2..3] + ":" + faculty_list.text[4..8] + ":" + faculty_list.text[9..10], n.xpath("./td/table/tr/td"))
            Fdinner.new(date: today, menu: menuString).save
          end
        end
      end
    end
    ####################교수회관 끝################
    
    #####################스카이라운지 시작#################
    sky.each_with_index do |n, num|
      unless num==0 || num==3
      
        sky_list=n.xpath("./td[@class='headerStyle']")
        
        if sky_list.text.to_s[0..2] == "메뉴A"
          if Menua.find_by(date: today) == nil
            menuString = htmlToString(sky_list.text.to_s[3..4] + ":" + sky_list.text.to_s[5..9] + ":" + sky_list.text.to_s[10..11], n.xpath("./td/table/tr/td"))
            Menua.new(date: today, menu: menuString).save
          end
        elsif sky_list.text.to_s[0..2]=="메뉴B"
          if Menub.find_by(date: today)==nil
            menuString = htmlToString(sky_list.text.to_s[3..4] + ":" + sky_list.text.to_s[5..9] + ":" + sky_list.text.to_s[10..11], n.xpath("./td/table/tr/td"))
            Menub.new(date: today, menu: menuString).save
          end
        end
      end
    end
    ###############################스카이라운지 파싱 끝######################
  end
end