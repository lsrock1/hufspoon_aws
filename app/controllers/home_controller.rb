require 'nokogiri'
require 'open-uri'
require 'uri'
require 'roo'
require 'write_xlsx'
require 'net/https'
require "resolv-replace.rb"

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
      cookies.permanent[@menu.kname.to_sym]=0
      if cookies[@menu.kname.to_sym]==nil
        session[@menu.kname.to_sym]=0
      end
      @menu.u_like-=1
      if @menu.u_like<0
        @menu.u_like=0
      end
      @menu.save
    else
      @menu.u_like+=1
      cookies.permanent[@menu.kname.to_sym]=1
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
   @id=params[:id].to_i
   @day=params[:day]
   
   #루트로 접속하면 번역은 0이고 데이는 nil이 된다
   if @id==0&&@day==nil
     if cookies[:my_language]!=nil
       @id=cookies[:my_language].to_i
     end
   end
   cookies.permanent[:my_language]=@id
   
   
    begin
      time=Date.parse(@day) 
    rescue
      time=Time.new.in_time_zone("Seoul")
       dd=time.day
       mm=time.month
        if dd<10 
          dd='0'+dd.to_s
        end
          
        if mm<10 
            mm='0'+mm.to_s
        end 
       @day=time.year.to_s+mm.to_s+dd.to_s
    end
    
    
    # #요일
    @w=time.wday
    #선택한 날짜
    @y=time.year
    @d=time.day
    @m=time.month
    
    #아예 처음이면
    
    check=Lunch1.find_by(:date => @day)
    begin
      if check==nil
        parsing_func(@day)
      end
    rescue
    end
    
    if @w==0
      r_all=Rest.all
      len=r_all.length
      seed_id=rand(0..len-1)
      @ran_rest=r_all[seed_id]
    end#일요일이면 레스토랑 추천!
    
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
    snack=Snack.find_by(:date =>@day)
    @register=snack
    if snack!=nil
      snack=snack.menu
      snack=snack.split("$")
      snack.each do|s|
        if s.index("(")!=nil
          s=s.strip
          s=s.gsub('*', '')
          s=s.sub("원"," won")
          sfirst=s.index("(")-1
          food=s[0..sfirst]
          food=food.split("/")
          
          
          food.each do |f|
            temp=""
            judvar=checkexist(f,@id)
            if judvar==1
              temp=transout(f,@id)
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
    end
    
    
    innum=0
    breakfast=Breakfast.find_by(:date => @day)
    unless breakfast==nil
      breakfast=breakfast.menu
      breakfast=breakfast.split("$")
      @breakfasttime=breakfast.shift
      breakfast.each do |l|
        if l.index(':')!=nil
          @breakfastingre.concat(makeingre(l,@id))
        elsif l[-1]=="l"
          @breakfastkcal=l
        elsif l[-1]=="원"
          @breakfastprice=l[0..-2]+"won"
        else
          xfood=l.strip
          judvar=checkexist(xfood,@id)
          if judvar==1
            @breakfast.push(transout(xfood,@id))
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
          
        innum=1+innum
      end
    end
    
  
    innum=0
    lunch1=Lunch1.find_by(:date => @day)
    
    
    unless lunch1==nil
      lunch1=lunch1.menu
      lunch1=lunch1.split("$")
      @lunch1time=lunch1.shift
      lunch1.each do |l|
        if l.index(':')!=nil
          @lunch1ingre.concat(makeingre(l,@id))
        elsif l[-1]=="l"
          @lunch1kcal=l
        elsif l[-1]=="원"
          @lunch1price=l[0..-2]+"won"
        else
          xfood=l.strip
          judvar=checkexist(xfood,@id)
          if judvar==1
            @lunch1.push(transout(xfood,@id))
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
          
        innum=1+innum
      end
    end
    
    
    innum=0
    lunch2=Lunch2.find_by(:date => @day)
    unless lunch2==nil
      lunch2=lunch2.menu
      lunch2=lunch2.split("$")
      @lunch2time=lunch2.shift
      lunch2.each do |l|
        if l.index(':')!=nil
          @lunch2ingre.concat(makeingre(l,@id))
        elsif l[-1]=="l"
          @lunch2kcal=l
        elsif l[-1]=="원"
          @lunch2price=l[0..-2]+"won"
        else
          xfood=l.strip
          judvar=checkexist(xfood,@id)
          if judvar==1
            @lunch2.push(transout(xfood,@id))
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
          
        innum=1+innum
      end
    end
    
    innum=0
    lunchnoodle=Lunchnoodle.find_by(:date => @day)
    unless lunchnoodle==nil
      lunchnoodle=lunchnoodle.menu
      lunchnoodle=lunchnoodle.split("$")
      @lunchnoodletime=lunchnoodle.shift
      lunchnoodle.each do |l|
        if l.index(':')!=nil
          @lunchnoodleingre.concat(makeingre(l,@id))
        elsif l[-1]=="l"
          @lunchnoodlekcal=l
        elsif l[-1]=="원"
          @lunchnoodleprice=l[0..-2]+"won"
        else
          xfood=l.strip
          judvar=checkexist(xfood,@id)
          if judvar==1
            @lunchnoodle.push(transout(xfood,@id))
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
          
        innum=1+innum
      end
    end
    
    innum=0
    dinner=Dinner.find_by(:date => @day)
    unless dinner==nil
      dinner=dinner.menu
      dinner=dinner.split("$")
      @dinnertime=dinner.shift
      dinner.each do |l|
        if l.index(':')!=nil
          @dinneringre.concat(makeingre(l,@id))
        elsif l[-1]=="l"
          @dinnerkcal=l
        elsif l[-1]=="원"
          @dinnerprice=l[0..-2]+"won"
        else
          xfood=l.strip
          judvar=checkexist(xfood,@id)
          if judvar==1
            @dinner.push(transout(xfood,@id))
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
          
        innum=1+innum
      end
    end
    
    
    innum=0
    flunch=Flunch.find_by(:date => @day)
    unless flunch==nil
      flunch=flunch.menu
      flunch=flunch.split("$")
      @flunchtime=flunch.shift
      flunch.each do |l|
        if l[-1]=="l"
          @flunchkcal=l
        elsif l[-1]=="원"
          @flunchprice=l[0..-2]+" won"
        else
          if l.index("(")!=nil
            xfirst=l.index("(")
            xfood=l[0..(xfirst-1)].strip
            @flunchingre.concat(makeingre(l[xfirst..-1],@id))
          else
            xfood=l.strip
          end
          
          #메뉴가 이상한 문자로 엮여있을 경우
          if xfood.index("&")!=nil||xfood.index("/")!=nil||xfood.index("-")!=nil
            @flunch.push(spliter(xfood,@id))
            if innum==0
              @flunch_main=how_like(xfood,0)
            end
          else
            
            judvar=checkexist(xfood,@id)
            if judvar==1
              @flunch.push(transout(xfood,@id))
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
        innum=1+innum
      end
    end
    
    innum=0
    fdinner=Fdinner.find_by(:date => @day)
    unless fdinner==nil
      fdinner=fdinner.menu
      fdinner=fdinner.split("$")
      @fdinnertime=fdinner.shift
      fdinner.each do |l|
        if l[-1]=="l"
          @fdinnerkcal=l
        elsif l[-1]=="원"
          @fdinnerprice=l[0..-2]+" won"
        else
          if l.index("(")!=nil
            xfirst=l.index("(")
            xfood=l[0..(xfirst-1)].strip
            @fdinneringre.concat(makeingre(l[xfirst..-1],@id))
          else
            xfood=l.strip
          end
          
          #메뉴가 이상한 문자로 엮여있을 경우
          if xfood.index("&")!=nil||xfood.index("/")!=nil||xfood.index("-")!=nil
            @fdinner.push(spliter(xfood,@id))
            if innum==0
              @fdinner_main=how_like(xfood,0)
            end
          else
            
            judvar=checkexist(xfood,@id)
            if judvar==1
              @fdinner.push(transout(xfood,@id))
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
        innum=innum+1
      end
    end
    
    innum=0
    menua=Menua.find_by(:date => @day)
    unless menua==nil
      menua=menua.menu
      menua=menua.split("$")
      @menuatime=menua.shift
      menua.each do |l|
        if l[-1]=="l"
          @menuakcal=l
        elsif l[-1]=="원"
          @menuaprice=l[0..-2]+" won"
        else
          if l.index("(")!=nil
            xfirst=l.index("(")
            xfood=l[0..(xfirst-1)].strip
            @menuaingre.concat(makeingre(l[xfirst..-1],@id))
          else
            xfood=l.strip
          end
          
          #메뉴가 이상한 문자로 엮여있을 경우
          if xfood.index("&")!=nil||xfood.index("/")!=nil||xfood.index("-")!=nil
            @menua.push(spliter(xfood,@id))
            if innum==0
              @menua_main=how_like(xfood,0)
            end
          else
            
            judvar=checkexist(xfood,@id)
            if judvar==1
              @menua.push(transout(xfood,@id))
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
        innum=1+innum
      end
    end
    
    innum=0
    menub=Menub.find_by(:date => @day)
    unless menub==nil
      menub=menub.menu
      menub=menub.split("$")
      @menubtime=menub.shift
      menub.each do |l|
        if l[-1]=="l"
          @menubkcal=l
        elsif l[-1]=="원"
          @menubprice=l[0..-2]+" won"
        else
          if l.index("(")!=nil
            xfirst=l.index("(")
            xfood=l[0..(xfirst-1)].strip
            @menubingre.concat(makeingre(l[xfirst..-1],@id))
          else
            xfood=l.strip
          end
          
          #메뉴가 이상한 문자로 엮여있을 경우
          if xfood.index("&")!=nil||xfood.index("/")!=nil||xfood.index("-")!=nil
            @menub.push(spliter(xfood,@id))
            if innum==0
              @menub_main=how_like(xfood,0)
            end
          else
            
            judvar=checkexist(xfood,@id)
            if judvar==1
              @menub.push(transout(xfood,@id))
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
        innum=innum+1
      end
    end
    
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