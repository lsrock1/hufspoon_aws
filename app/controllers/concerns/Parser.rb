require 'open-uri'

module Parser
  extend ActiveSupport::Concern
  
  def parsing_func today
    mainadd="https://webs.hufs.ac.kr/jsp/HUFS/cafeteria/viewWeek.jsp"
    resultadd=mainadd+"?startDt="+today+"&endDt="+today+"&caf_name="+URI.encode("인문관식당")+"&caf_id=h101"
    doc = Nokogiri::HTML(open(resultadd))
    humanity=doc.xpath("//html/body/form/table/tr")
    ###################인문관식당 파싱##########################
    
    resultadd=mainadd+"?startDt="+today+"&endDt="+today+"&caf_name="+URI.encode("교수회관식당")+"&caf_id=h102"
    doc =Nokogiri::HTML(open(resultadd))
    faculty=doc.xpath("//html/body/form/table/tr")
    ###################교수회관 파싱##############
    
    
    resultadd=mainadd+"?startDt="+today+"&endDt="+today+"&caf_name="+URI.encode("스카이라운지")+"&caf_id=h103"
    doc =Nokogiri::HTML(open(resultadd))
    sky=doc.xpath("//html/body/form/table/tr")
    ###############스카이라운지 파싱##############
    
    ##############인문관식당 파싱 자료 분류#############
    #snack
    if Snack.find_by(:date => today)==nil
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
    
    num=0
    humanity.each do |n|
      unless num==0 
      
        humanity_list=n.xpath("./td[@class='headerStyle']")
        
        if humanity_list.text[0..4]=="중식(1)"
          if Lunch1.find_by(:date => today)==nil
            #시간 저장
            lunch1=humanity_list.text[5..6]+":"+humanity_list.text[7..11]+":"+humanity_list.text[12..13]
            
            n.xpath("./td/table/tr/td").each do|x|
              if x.text!=""
                string=x.text
                if string.index("(")!=nil
                  substring=string[string.index("(")..string.index(")")]
                  string.sub!(substring,"")
                  string=string+'$'+substring[1...-1]
                end
                if string.index(",")!=nil&&string[-1]!='원'
                  string.sub!(",","$")
                end
                lunch1=lunch1+"$"+string
              end
            end
            Lunch1.new(:date => today,:menu =>lunch1).save
          end
        elsif humanity_list.text[0..4]=="중식(2)"
          if Lunch2.find_by(:date => today)==nil
            lunch2=humanity_list.text[5..6]+":"+humanity_list.text[7..11]+":"+humanity_list.text[12..13]
            n.xpath("./td/table/tr/td").each do|x|
              if x.text!=""
                string=x.text
                if string.index("(")!=nil
                  substring=string[string.index("(")..string.index(")")]
                  string.sub!(substring,"")
                  string=string+'$'+substring[1...-1]
                end
                if string.index(",")!=nil&&string[-1]!='원'
                  string.sub!(",","$")
                end
                lunch2=lunch2+"$"+string
              end
            end
            Lunch2.new(:date => today,:menu => lunch2).save
          end
        elsif humanity_list.text[0..4]=="중식(면)"
          if Lunchnoodle.find_by(:date =>today)==nil
            lunchnoodle= humanity_list.text[5..6]+":"+humanity_list.text[7..11]+":"+humanity_list.text[12..13]
            n.xpath("./td/table/tr/td").each do|x|
              if x.text!=""
                string=x.text
                if string.index("(")!=nil
                  substring=string[string.index("(")..string.index(")")]
                  string.sub!(substring,"")
                  string=string+'$'+substring[1...-1]
                end
                if string.index(",")!=nil&&string[-1]!='원'
                  string.sub!(",","$")
                end
                lunchnoodle=lunchnoodle+"$"+string
              end
            end
            Lunchnoodle.new(:date => today,:menu =>lunchnoodle).save
          end
        elsif humanity_list.text[0..1]=="조식"
          if Breakfast.find_by(:date =>today)==nil
            breakfast = humanity_list.text[2..3]+":"+humanity_list.text[4..8]+":"+humanity_list.text[9..10]
            n.xpath("./td/table/tr/td").each do|x|
              if x.text!=""
                string=x.text
                if string.index("(")!=nil
                  substring=string[string.index("(")..string.index(")")]
                  string.sub!(substring,"")
                  string=string+'$'+substring[1...-1]
                end
                if string.index(",")!=nil&&string[-1]!='원'
                  string.sub!(",","$")
                end
                breakfast=breakfast+"$"+string
              end
            end
            Breakfast.new(:date => today,:menu => breakfast).save
          end
        elsif humanity_list.text[0..1]=="석식"
          if Dinner.find_by(:date =>today)==nil
            dinner= humanity_list.text[2..3]+":"+humanity_list.text[4..8]+":"+humanity_list.text[9..10]
            n.xpath("./td/table/tr/td").each do|x|
              if x.text!=""
                string=x.text
                if string.index("(")!=nil
                  substring=string[string.index("(")..string.index(")")]
                  string.sub!(substring,"")
                  string=string+'$'+substring[1...-1]
                end
                if string.index(",")!=nil&&string[-1]!='원'
                  string.sub!(",","$")
                end
                dinner=dinner+"$"+string
              end
            end
            Dinner.new(:date =>today,:menu =>dinner).save
          end
        end
      end
      num=num+1
    end
    ################인문관식당 파싱 분석 끝####################
    
    ###################교수회관식당 파싱 분석 시작##############
    num=0
    faculty.each do |n|
      unless num==0 ||num==3
      
        faculty_list=n.xpath("./td[@class='headerStyle']")
        
        if faculty_list.text[0..1]=="중식"
          if Flunch.find_by(:date => today)==nil
            flunch = faculty_list.text[2..3]+":"+faculty_list.text[4..8]+":"+faculty_list.text[9..10]
            n.xpath("./td/table/tr/td").each do|x|
              if x.text!=""
                string=x.text
                if string.index("(")!=nil
                  substring=string[string.index("(")..string.index(")")]
                  string.sub!(substring,"")
                  string=string+'$'+substring[1...-1]
                end
                if string.index(",")!=nil&&string[-1]!='원'
                  string.sub!(",","$")
                end
                flunch=flunch+"$"+string
              end
            end
            Flunch.new(:date => today, :menu =>flunch).save
          end
        elsif faculty_list.text.to_s[0..1]=="석식"
          if Fdinner.find_by(:date => today)==nil
            fdinner= faculty_list.text[2..3]+":"+faculty_list.text[4..8]+":"+faculty_list.text[9..10]
            n.xpath("./td/table/tr/td").each do|x|
              if x.text!=""
                string=x.text
                if string.index("(")!=nil
                  substring=string[string.index("(")..string.index(")")]
                  string.sub!(substring,"")
                  string=string+'$'+substring[1...-1]
                end
                if string.index(",")!=nil&&string[-1]!='원'
                  string.sub!(",","$")
                end
                fdinner=fdinner+"$"+string
              end
            end
            Fdinner.new(:date => today,:menu =>fdinner).save
          end
        end
      end
      num=num+1
    end
    ####################교수회관 끝################
    
    #####################스카이라운지 시작#################
    num=0
    sky.each do |n|
      unless num==0 ||num==3
      
        sky_list=n.xpath("./td[@class='headerStyle']")
        
        if sky_list.text.to_s[0..2]=="메뉴A"
          if Menua.find_by(:date => today)==nil
            menua=sky_list.text.to_s[3..4]+":"+sky_list.text.to_s[5..9]+":"+sky_list.text.to_s[10..11]
            n.xpath("./td/table/tr/td").each do|x|
              if x.text!=""
                string=x.text
                if string.index("(")!=nil
                  substring=string[string.index("(")..string.index(")")]
                  string.sub!(substring,"")
                  string=string+'$'+substring[1...-1]
                end
                if string.index(",")!=nil&&string[-1]!='원'
                  string.sub!(",","$")
                end
                menua=menua+"$"+string
              end
            end
            Menua.new(:date => today,:menu =>menua).save
          end
        elsif sky_list.text.to_s[0..2]=="메뉴B"
          if Menub.find_by(:date =>today)==nil
            menub=sky_list.text.to_s[3..4]+":"+sky_list.text.to_s[5..9]+":"+sky_list.text.to_s[10..11]
            n.xpath("./td/table/tr/td").each do|x|
              if x.text!=""
                string=x.text
                if string.index("(")!=nil
                  substring=string[string.index("(")..string.index(")")]
                  string.sub!(substring,"")
                  string=string+'$'+substring[1...-1]
                end
                if string.index(",")!=nil&&string[-1]!='원'
                  string.sub!(",","$")
                end
                menub=menub+"$"+string
              end
            end
            Menub.new(:date =>today,:menu => menub).save
          end
        end
        
      end
      num=num+1
    end
    ###############################스카이라운지 파싱 끝######################
  end
end