require 'nokogiri'
require 'open-uri'
require 'uri'
require 'roo'
require 'write_xlsx'
require 'net/https'

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
  
  def like
    id=params[:id]
    @menu=Menulist.find(id)
    if cookies[@menu.kname.to_sym]=="1"||session[@menu.kname.to_sym]=="1"#좋아요
      cookies[@menu.kname.to_sym]=0
      if cookies[@menu.kname.to_sym]==nil
        session[@menu.kname.to_sym]=0
      end
      @menu.u_like-=1
      @menu.save
    else
      @menu.u_like+=1
      cookies[@menu.kname.to_sym]=1
      if cookies[@menu.kname.to_sym]!="1"
        session[@menu.kname.to_sym]=1
      end
      @menu.save
    end
    respond_to do |format|
      format.json { render :json => { :like => @menu.u_like } }
    end
  end


  
  def index
   tid=params[:id].to_i
   @id=tid
   @day=params[:day]
   
   #루트로 접속하면 번역은 0이고 데이는 nil이 된다
   if @id==0&&@day==nil
     if cookies[:my_language]!=nil
       tid=cookies[:my_language].to_i
       @id=cookies[:my_language].to_i
     end
   end
   cookies[:my_language]=tid
   mainadd="https://webs.hufs.ac.kr/jsp/HUFS/cafeteria/viewWeek.jsp"
    if @day==nil
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
    else
      today=params[:day]
      @time=Date.parse(today) 
    end
    @day=today
    # #요일
    @w=@time.wday
    #선택한 날짜
    @y=@time.year
    @d=@time.day
    @m=@time.month
    
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
    
    @snack=[]
    @breakfast=[]
    @lunch1=[]
    @lunch2=[]
    @lunchnoodle=[]
    @dinner=[]
    
    @flunch=[]
    @fdinner=[]
    
    @menua=[]
    @menub=[]
    
    @breakfastingre=[]
    @lunch1ingre=[]
    @lunch2ingre=[]
    @lunchnoodleingre=[]
    @dinneringre=[]
    
    @flunchingre=[]
    @fdinneringre=[]
    
    @menuaingre=[]
    @menubingre=[]
    ##############인문관식당 파싱 자료 분류#############
    #snack
    snack=@nice.xpath("./td[@class='listStyle2']").text
    snack=snack.split()
    snack.each do|s|
      if s.index("(")!=nil
        s=s.strip
        s=s.gsub('*', '')
        s=s.sub("원"," won")
        sfirst=s.index("(")-1
        food=s[0..sfirst]
        food=food.split("/")
        
        
        food.each do |f|
          # if num!=0
          #   temp=temp+"/"
          # end
          temp=""
          judvar=checkexist(f,tid)
          if judvar==1
            temp=transout(f,tid)
          elsif judvar==0
            temp=f
          else
            temp=f
            new_menu(f)
          end
          @snack.push(temp+" "+s[sfirst+1..-1])
        end
        
      end
    end
    
    num=0
    @nice.each do |n|
      innum=0
      unless num==0 
      
        @one=n.xpath("./td[@class='headerStyle']")
        
        if @one.text.to_s[0..4]=="중식(1)"
          @lunch1time=@one.text.to_s[5..6]+":"+@one.text.to_s[7..11]+":"+@one.text.to_s[12..13]
          n.xpath("./td/table/tr/td").each do|x|
            if x.text!=""
              if x.text.index(':')!=nil
                @lunch1ingre.concat(makeingre(x.text,tid))
              elsif x.text[-1]=="l"
                @lunch1kcal=x.text
              elsif x.text[-1]=="원"
                @lunch1price=x.text[0..-2]+" won"
              else
                xfood=x.text.strip
                
                judvar=checkexist(xfood,tid)
                if judvar==1
                  @lunch1.push(transout(xfood,tid))
                elsif judvar==0
                  @lunch1.push(xfood)
                else
                  @lunch1.push(xfood)
                  new_menu(xfood)
                end
                if innum==0
                  @lunch1_main=Menulist.find_by(:kname => xfood)
                end
              end
            end
            innum=innum+1
          end
        elsif @one.text.to_s[0..4]=="중식(2)"
          @lunch2time=@one.text.to_s[5..6]+":"+@one.text.to_s[7..11]+":"+@one.text.to_s[12..13]
          n.xpath("./td/table/tr/td").each do|x|
            if x.text!=""
              if x.text.index(':')!=nil
                @lunch2ingre.concat(makeingre(x.text,tid))
              elsif x.text[-1]=="l"
                @lunch2kcal=x.text
              elsif x.text[-1]=="원"
                @lunch2price=x.text[0..-2]+" won"
              else
                xfood=x.text.strip
                
                judvar=checkexist(xfood,tid)
                if judvar==1
                  @lunch2.push(transout(xfood,tid))
                elsif judvar==0
                  @lunch2.push(xfood)
                else
                  @lunch2.push(xfood)
                  new_menu(xfood)
                end
                if innum==0
                  @lunch2_main=Menulist.find_by(:kname => xfood)
                end
              end
            end
            innum=innum+1
          end
        elsif @one.text.to_s[0..4]=="중식(면)"
        @lunchnoodletime=@one.text.to_s[5..6]+":"+@one.text.to_s[7..11]+":"+@one.text.to_s[12..13]
          n.xpath("./td/table/tr/td").each do|x|
            if x.text!=""
              if x.text.index(':')!=nil
                @lunchnoodleingre.concat(makeingre(x.text,tid))
              elsif x.text[-1]=="l"
                @lunchnoodlekcal=x.text
              elsif x.text[-1]=="원"
                @lunchnoodleprice=x.text[0..-2]+" won"
              else
                xfood=x.text.strip
                
                judvar=checkexist(xfood,tid)
                if judvar==1
                  @lunchnoodle.push(transout(xfood,tid))
                elsif judvar==0
                  @lunchnoodle.push(xfood)
                else
                  @lunchnoodle.push(xfood)
                  new_menu(xfood)
                end
                if innum==0
                  @lunchnoodle_main=Menulist.find_by(:kname => xfood)
                end
              end
            end
            innum=innum+1
          end
        elsif @one.text.to_s[0..1]=="조식"
          @breakfasttime=@one.text.to_s[2..3]+":"+@one.text.to_s[4..8]+":"+@one.text.to_s[9..10]
          n.xpath("./td/table/tr/td").each do|x|
            if x.text!=""
              if x.text.index(':')!=nil
                @breakfastingre.concat(makeingre(x.text,tid))
              elsif x.text[-1]=="l"
                @breakfastkcal=x.text
              elsif x.text[-1]=="원"
                @breakfastprice=x.text[0..-2]+" won"
              else
                xfood=x.text.strip
                
                judvar=checkexist(xfood,tid)
                if judvar==1
                  @breakfast.push(transout(xfood,tid))
                elsif judvar==0
                  @breakfast.push(xfood)
                else
                  @breakfast.push(xfood)
                  new_menu(xfood)
                end
                if innum==0
                  @breakfast_main=Menulist.find_by(:kname => xfood)
                end
              end
            end
            innum=innum+1
          end
        elsif @one.text.to_s[0..1]=="석식"
          @dinnertime=@one.text.to_s[2..3]+":"+@one.text.to_s[4..8]+":"+@one.text.to_s[9..10]
          n.xpath("./td/table/tr/td").each do|x|
            if x.text!=""
              if x.text.index(':')!=nil
                @dinneringre.concat(makeingre(x.text,tid))
              elsif x.text[-1]=="l"
                @dinnerkcal=x.text
              elsif x.text[-1]=="원"
                @dinnerprice=x.text[0..-2]+" won"
              else
                xfood=x.text.strip
                
                judvar=checkexist(xfood,tid)
                if judvar==1
                  @dinner.push(transout(xfood,tid))
                elsif judvar==0
                  @dinner.push(xfood)
                else
                  @dinner.push(xfood)
                  new_menu(xfood)
                end
                if innum==0
                  @dinner_main=Menulist.find_by(:kname => xfood)
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
                  @flunchingre.concat(makeingre(x.text[xfirst..-1],tid))
                else
                  xfood=x.text.strip
                end
                
                #메뉴가 이상한 문자로 엮여있을 경우
                if xfood.index("&")!=nil||xfood.index("/")!=nil||xfood.index("-")
                  @flunch.push(spliter(xfood,tid))
                  if innum==0
                    @flundh_main=how_like(xfood,0)
                  end
                else
                  
                  judvar=checkexist(xfood,tid)
                  if judvar==1
                    @flunch.push(transout(xfood,tid))
                  elsif judvar==0
                    @flunch.push(xfood)
                  else
                    @flunch.push(xfood)
                    new_menu(xfood)
                  end
                  if innum==0
                    @flunch_main=Menulist.find_by(:kname => xfood)
                  end
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
                  @fdinneringre.concat(makeingre(x.text[xfirst..-1],tid))
                else
                  xfood=x.text.strip
                end
                
                if xfood.index("&")!=nil||xfood.index("/")!=nil||xfood.index("-")
                  @fdinner.push(spliter(xfood,tid))
                  if innum==0
                    @fdinner_main=how_like(xfood,0)
                  end
                else
                  
                  judvar=checkexist(xfood,tid)
                  if judvar==1
                    @fdinner.push(transout(xfood,tid))
                  elsif judvar==0
                    @fdinner.push(xfood)
                  else
                    @fdinner.push(xfood)
                    new_menu(xfood)
                  end
                  if innum==0
                    @fdinner_main=Menulist.find_by(:kname => xfood)
                  end
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
                  @menuaingre.concat(makeingre(x.text[xfirst..-1],tid))
                else
                  xfood=x.text.strip
                end
                
                if xfood.index("&")!=nil||xfood.index("/")!=nil||xfood.index("-")
                  @menua.push(spliter(xfood,tid))
                  if innum==0
                    @menua_main=how_like(xfood,0)
                  end
                else
                  
                  judvar=checkexist(xfood,tid)
                  if judvar==1
                    @menua.push(transout(xfood,tid))
                  elsif judvar==0
                    @menua.push(xfood)
                  else
                    @menua.push(xfood)
                    new_menu(xfood)
                  end
                  if innum==0
                    @menua_main=Menulist.find_by(:kname => xfood)
                  end
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
                  @menubingre.concat(makeingre(x.text[xfirst..-1],tid))
                  
                else
                  xfood=x.text.strip
                end
                
                if xfood.index("&")!=nil||xfood.index("/")!=nil||xfood.index("-")
                  @flunch.push(spliter(xfood,tid))
                  if innum==0
                    @menua_main=how_like(xfood,0)
                  end
                else
                  
                  judvar=checkexist(xfood,tid)
                  if judvar==1
                    @menub.push(transout(xfood,tid))
                  elsif judvar==0
                    @menub.push(xfood)
                  else
                    @menub.push(xfood)
                    new_menu(xfood)
                  end
                  if innum==0
                    @menub_main=Menulist.find_by(:kname => xfood)
                  end
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
        @breakfastingre=@breakfastingre.uniq
    @lunch1ingre=@lunch1ingre.uniq
    @lunch2ingre=@lunch2ingre.uniq
    @lunchnoodleingre=@lunchnoodleingre.uniq
    @dinneringre=@dinneringre.uniq
    
    @flunchingre=@flunchingre.uniq
    @fdinneringre=@fdinneringre.uniq
    
    @menuaingre=@menuaingre.uniq
    @menubingre=@menubingre.uniq
    
    
  end
  
  
end

# developer mail address lsrock1@naver.com