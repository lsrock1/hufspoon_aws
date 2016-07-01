require 'nokogiri'
require 'open-uri'
require 'uri'
require 'roo'
require 'write_xlsx'

class HomeController < ApplicationController

  
  def newadmin
    if Admin.find_by(:email => ENV["ADMIN_ID"])!=nil
      redirect_to :back
    else
    admin=Admin.new
    admin.email=ENV["ADMIN_ID"]
    admin.password=ENV["ADMIN_PASS"]
    admin.save
    redirect_to "/"
    end
  end



  
  def index
   tid=params[:id].to_i
   mainadd="https://webs.hufs.ac.kr/jsp/HUFS/cafeteria/viewWeek.jsp"
    @time=Time.new.in_time_zone("Seoul")
    dd=@time.day
    mm=@time.month
    
    if dd<10 
        dd='0'+dd.to_s
    end
      
    if mm<10 
        mm='0'+mm.to_s
    end 
    
    today=@time.year.to_s+mm.to_s+dd.to_s
    
    resultadd=mainadd+"?startDt="+today+"&endDt="+today+"&caf_name="+URI.encode("인문관식당")+"&caf_id=h101"
    doc = Nokogiri::HTML(open(resultadd))
    @nice=doc.xpath("//html/body/form/table/tr")
    ###################인문관식당 파싱##########################
    
    resultadd=mainadd+"?startDt="+today+"&endDt="+today+"&caf_name="+URI.encode("교수회관식당")+"&caf_id=h102"
    doc =Nokogiri::HTML(open(resultadd))
    @fach=doc.xpath("//html/body/form/table/tr")
    ###################교수회관 파싱##############
    
    
    resultadd=mainadd+"?startDt="+today+"&endDt="+today+"&caf_name="+URI.encode("스카이라운지")+"&caf_id=h103"
    doc =Nokogiri::HTML(open(resultadd))
    @sky=doc.xpath("//html/body/form/table/tr")
    ###############스카이라운지 파싱##############
    
    
    @breakfast=[]
    @lunch1=[]
    @lunch2=[]
    @lunchnoodle=[]
    @dinner=[]
    
    @flunch=[]
    @fdinner=[]
    
    @menua=[]
    @menub=[]
    ##############인문관식당 파싱 자료 분류#############
    num=0
    @nice.each do |n|
      innum=0
      unless num==0 
      
        @one=n.xpath("./td[@class='headerStyle']")
        
        if @one.text.to_s[0..4]=="중식(1)"
          @lunch1time=@one.text.to_s[5..6]+":"+@one.text.to_s[7..11]+":"+@one.text.to_s[12..13]
          n.xpath("./td/table/tr/td").each do|x|
            if x.text!=""
              if x.text[-1]=="l"
                @lunch1kcal=x.text
              elsif x.text[-1]=="원"
                @lunch1price=x.text[0..-2]+" won"
              else
                xfood=x.text.strip
                if checkexist(xfood,tid)!=nil
                  @lunch1.push(transout(xfood,tid))
                else
                  @lunch1.push(xfood)
                  new_menu(xfood)
                end
              end
            end
            innum=innum+1
          end
        elsif @one.text.to_s[0..4]=="중식(2)"
          @lunch2time=@one.text.to_s[5..6]+":"+@one.text.to_s[7..11]+":"+@one.text.to_s[12..13]
          n.xpath("./td/table/tr/td").each do|x|
            if x.text!=""
              if x.text[-1]=="l"
                @lunch2kcal=x.text
              elsif x.text[-1]=="원"
                @lunch2price=x.text[0..-2]+" won"
              else
                xfood=x.text.strip
                if checkexist(xfood,tid)!=nil
                  @lunch2.push(transout(xfood,tid))
                else
                  @lunch2.push(xfood)
                  new_menu(xfood)
                end
              end
            end
            innum=innum+1
          end
        elsif @one.text.to_s[0..4]=="중식(면)"
        @lunchnoodletime=@one.text.to_s[5..6]+":"+@one.text.to_s[7..11]+":"+@one.text.to_s[12..13]
          n.xpath("./td/table/tr/td").each do|x|
            if x.text!=""
              if x.text[-1]=="l"
                @lunchnoodlekcal=x.text
              elsif x.text[-1]=="원"
                @lunchnoodleprice=x.text[0..-2]+" won"
              else
                xfood=x.text.strip
                if checkexist(xfood,tid)!=nil
                  @lunchnoodle.push(transout(xfood,tid))
                else
                  @lunchnoodle.push(xfood)
                  new_menu(xfood)
                end
              end
            end
            innum=innum+1
          end
        elsif @one.text.to_s[0..1]=="조식"
          @breakfasttime=@one.text.to_s[2..3]+":"+@one.text.to_s[4..8]+":"+@one.text.to_s[9..10]
          n.xpath("./td/table/tr/td").each do|x|
            if x.text!=""
              if x.text[-1]=="l"
                @breakfastkcal=x.text
              elsif x.text[-1]=="원"
                @breakfastprice=x.text[0..-2]+" won"
              else
                xfood=x.text.strip
                if checkexist(xfood,tid)!=nil
                  @breakfast.push(transout(xfood,tid))
                else
                  @breakfast.push(xfood)
                  new_menu(xfood)
                end
              end
            end
            innum=innum+1
          end
        elsif @one.text.to_s[0..1]=="석식"
          @dinnertime=@one.text.to_s[2..3]+":"+@one.text.to_s[4..8]+":"+@one.text.to_s[9..10]
          n.xpath("./td/table/tr/td").each do|x|
            if x.text!=""
              if x.text[-1]=="l"
                @dinnerkcal=x.text
              elsif x.text[-1]=="원"
                @dinnerprice=x.text[0..-2]+" won"
              else
                xfood=x.text.strip
                if checkexist(xfood,tid)!=nil
                  # @dinner.push(Menulist.find_by(:kname => x.text).ename.to_s)
                  @dinner.push(transout(xfood,tid))
                else
                  @dinner.push(xfood)
                  new_menu(xfood)
                end
              end
            end
            innum=innum+1
          end
        else
          ##등록된 메뉴가 없을 경우엔 그냥 넘어감##
        end
        
      end
      num=num+1
    end
    ################인문관식당 파싱 분석 끝####################
    
    ###################교수회관식당 파싱 분석 시작##############
    num=0
    @fach.each do |n|
      innum=0
      unless num==0 ||num==3
      
        @one=n.xpath("./td[@class='headerStyle']")
        
        if @one.text.to_s[0..1]=="중식"
          @flunchtime=@one.text.to_s[2..3]+":"+@one.text.to_s[4..8]+":"+@one.text.to_s[9..10]
          n.xpath("./td/table/tr/td").each do|x|
            if x.text!=""
              if x.text[-1]=="l"
                @flunchkcal=x.text
              elsif x.text[-1]=="원"
                @flunchprice=x.text[0..-2]+" won"
              else
                if x.text.to_s.index("(")!=nil
                  xfirst=x.text.to_s.index("(")
                  xfood=x.text.to_s[0..(xfirst-1)].strip
                else
                  xfood=x.text.strip
                end
                if checkexist(xfood,tid)!=nil
                  @flunch.push(transout(xfood,tid))
                else
                  @flunch.push(xfood)
                  new_menu(xfood)
                end
              end
            end
            innum=innum+1
          end
        elsif @one.text.to_s[0..1]=="석식"
          @fdinnertime=@one.text.to_s[2..3]+":"+@one.text.to_s[4..8]+":"+@one.text.to_s[9..10]
          n.xpath("./td/table/tr/td").each do|x|
            if x.text!=""
              if x.text[-1]=="l"
                @fdinnerkcal=x.text
              elsif x.text[-1]=="원"
                @fdinnerprice=x.text[0..-2]+" won"
              else
                if x.text.to_s.index("(")!=nil
                  xfirst=x.text.to_s.index("(")
                  xfood=x.text.to_s[0..(xfirst-1)].strip
                else
                  xfood=x.text.strip
                end
                if checkexist(xfood,tid)!=nil
                  @fdinner.push(transout(xfood,tid))
                else
                  @fdinner.push(xfood)
                  new_menu(xfood)
                end
              end
            end
            innum=innum+1
          end
        else
          ##비어있으면 그냥 패스
        end
      end
      num=num+1
    end
    ####################3교수회관 끝################
    
    #####################스카이라운지 시작#################
    num=0
    @sky.each do |n|
      innum=0
      unless num==0 ||num==3
      
        @one=n.xpath("./td[@class='headerStyle']")
        
        if @one.text.to_s[0..2]=="메뉴A"
          @menuatime=@one.text.to_s[3..4]+":"+@one.text.to_s[5..9]+":"+@one.text.to_s[10..11]
          n.xpath("./td/table/tr/td").each do|x|
            if x.text!=""
              if x.text[-1]=="l"
                @menuakcal=x.text
              elsif x.text[-1]=="원"
                @menuaprice=x.text[0..-2]+" won"
              else
                if x.text.to_s.index("(")!=nil
                  xfirst=x.text.to_s.index("(")
                  xfood=x.text.to_s[0..(xfirst-1)].strip
                else
                  xfood=x.text.strip
                end
                if checkexist(xfood,tid)!=nil
                  @menua.push(transout(xfood,tid))
                else
                  @menua.push(xfood)
                  new_menu(xfood)
                end
              end
            end
            innum=innum+1
          end
        elsif @one.text.to_s[0..2]=="메뉴B"
          @menubtime=@one.text.to_s[3..4]+":"+@one.text.to_s[5..9]+":"+@one.text.to_s[10..11]
          n.xpath("./td/table/tr/td").each do|x|
            if x.text!=""
              if x.text[-1]=="l"
                @menubkcal=x.text
              elsif x.text[-1]=="원"
                @menubprice=x.text[0..-2]+" won"
              else
                if x.text.to_s.index("(")!=nil
                  xfirst=x.text.to_s.index("(")
                  xfood=x.text.to_s[0..(xfirst-1)].strip
                else
                  xfood=x.text.strip
                end
                if checkexist(xfood,tid)!=nil
                  @menub.push(transout(xfood,tid))
                else
                  @menub.push(xfood)
                  new_menu(xfood)
                end
              end
            end
            innum=innum+1
          end
        else
          ##비어있으면 그냥 패스
        end
      end
      num=num+1
    end
    ###############################스카이라운지 파싱 끝######################
  end
end

# developer mail address lsrock1@naver.com