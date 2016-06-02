require 'nokogiri'
require 'open-uri'
require 'uri'
require 'roo'
require 'write_xlsx'

class HomeController < ApplicationController
  def index
     
  end
  
  def resetid
  end
  

  
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



  
  def testmenu
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
    @empty="Cafeteria is not opend"
    
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
          @lunch1time=@one.text.to_s[5..-1]
          n.xpath("./td/table/tr/td").each do|x|
            if x.text!=""
              if innum==8
                @lunch1kcal=x.text
              elsif innum==9
                @lunch1price=x.text
              else
                if Menulist.find_by(:kname => x.text)!=nil
                  @lunch1.push(Menulist.find_by(:kname => x.text).ename.to_s)
                  
                else
                  @lunch1.push(x.text)
                  new_menu(x.text)
                end
              end
            end
            innum=innum+1
          end
        elsif @one.text.to_s[0..4]=="중식(2)"
          @lunch2time=@one.text.to_s[5..-1]
          n.xpath("./td/table/tr/td").each do|x|
            if x.text!=""
              if innum==8
                @lunch2kcal=x.text
              elsif innum==9
                @lunch2price=x.text
              else
                if Menulist.find_by(:kname => x.text)!=nil
                  @lunch2.push(Menulist.find_by(:kname => x.text).ename.to_s)
                else
                  @lunch2.push(x.text)
                  new_menu(x.text)
                end
              end
            end
            innum=innum+1
          end
        elsif @one.text.to_s[0..4]=="중식(면)"
        @lunchnoodletime=@one.text.to_s[5..-1]
          n.xpath("./td/table/tr/td").each do|x|
            if x.text!=""
              if innum==8
                @lunchnoodlekcal=x.text
              elsif innum==9
                @lunchnoodleprice=x.text
              else
                if Menulist.find_by(:kname => x.text)!=nil
                  @lunchnoodle.push(Menulist.find_by(:kname => x.text).ename.to_s)
                else
                  @lunchnoodle.push(x.text)
                  new_menu(x.text)
                end
              end
            end
            innum=innum+1
          end
        elsif @one.text.to_s[0..1]=="조식"
          @breakfasttime=@one.text.to_s[2..-1]
          n.xpath("./td/table/tr/td").each do|x|
            if x.text!=""
              if innum==8
                @breakfastkcal=x.text
              elsif innum==9
                @breakfastprice=x.text
              else
                if Menulist.find_by(:kname => x.text)!=nil
                  @breakfast.push(Menulist.find_by(:kname => x.text).ename.to_s)
                else
                  @breakfast.push(x.text)
                  new_menu(x.text)
                end
              end
            end
            innum=innum+1
          end
        elsif @one.text.to_s[0..1]=="석식"
          @dinnertime=@one.text.to_s[2..-1]
          n.xpath("./td/table/tr/td").each do|x|
            if x.text!=""
              if innum==8
                @dinnerkcal=x.text
              elsif innum==9
                @dinnerprice=x.text
              else
                if Menulist.find_by(:kname => x.text)!=nil
                  @dinner.push(Menulist.find_by(:kname => x.text).ename.to_s)
                else
                  @dinner.push(x.text)
                  new_menu(x.text)
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
          @flunchtime=@one.text.to_s[2..-1]
          n.xpath("./td/table/tr/td").each do|x|
            if x.text!=""
              if x.text[-1]=="l"
                @flunchkcal=x.text
              elsif x.text[-1]=="원"
                @flunchprice=x.text
              else
                if Menulist.find_by(:kname => x.text)!=nil
                  @flunch.push(Menulist.find_by(:kname => x.text).ename.to_s)
                else
                  @flunch.push(x.text)
                  new_menu(x.text)
                end
              end
            end
            innum=innum+1
          end
        elsif @one.text.to_s[0..1]=="석식"
          @fdinnertime=@one.text.to_s[2..-1]
          n.xpath("./td/table/tr/td").each do|x|
            if x.text!=""
              if x.text[-1]=="l"
                @fdinnerkcal=x.text
              elsif x.text[-1]=="원"
                @fdinnerprice=x.text
              else
                if Menulist.find_by(:kname => x.text)!=nil
                  @fdinner.push(Menulist.find_by(:kname => x.text).ename.to_s)
                else
                  @fdinner.push(x.text)
                  new_menu(x.text)
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
          @menuatime=@one.text.to_s[3..-1]
          n.xpath("./td/table/tr/td").each do|x|
            if x.text!=""
              if x.text[-1]=="l"
                @menuakcal=x.text
              elsif x.text[-1]=="원"
                @menuaprice=x.text
              else
                if Menulist.find_by(:kname => x.text)!=nil
                  @menua.push(Menulist.find_by(:kname => x.text).ename.to_s)
                else
                  @menua.push(x.text)
                  new_menu(x.text)
                end
              end
            end
            innum=innum+1
          end
        elsif @one.text.to_s[0..2]=="메뉴B"
          @menubtime=@one.text.to_s[3..-1]
          n.xpath("./td/table/tr/td").each do|x|
            if x.text!=""
              if x.text[-1]=="l"
                @menubkcal=x.text
              elsif x.text[-1]=="원"
                @menubprice=x.text
              else
                if Menulist.find_by(:kname => x.text)!=nil
                  @menub.push(Menulist.find_by(:kname => x.text).ename.to_s)
                else
                  @menub.push(x.text)
                  new_menu(x.text)
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