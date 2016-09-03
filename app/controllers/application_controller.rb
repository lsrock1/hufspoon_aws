class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  def require_login
    unless admin_signed_in?
      redirect_to "/admins/sign_in"
    end
  end
  
  def require_session
    unless admin_signed_in?
      if session[:num]==nil||session[:name]==nil||session[:level]==nil
        redirect_to '/board/hufslogin'
      end
    end
  end
  
  def new_menu(a)
    
    nmenu=Menulist.new(:kname => a,:ename => a,:ername => a, :jnamea => a,:cname => a,:cnameb => a,:aname => a,:spanish => a,:germany => a, :italia => a,:portugal => a)
    nmenu.save
    
  end
  
  #a는 텍스트 b는 id코드
  def transout(a,b)
    if b==0#영어
      return Menulist.find_by(:kname => a).ename.to_s
    elsif b==1#일본어
      return Menulist.find_by(:kname => a).jnamea.to_s
    elsif b==2#중국어 간체
      return Menulist.find_by(:kname => a).cname.to_s
    elsif b==3# 중국어 번체
      return Menulist.find_by(:kname => a).cnameb.to_s
    elsif b==4#한국어
      return a
    elsif b==5#아랍어
      return Menulist.find_by(:kname => a).aname.to_s
    elsif b==6 #스페인어 
      return Menulist.find_by(:kname => a).spanish.to_s
    elsif b==7 #독일어
      return Menulist.find_by(:kname => a).germany.to_s
    elsif b==8 #이탈리아어
      return Menulist.find_by(:kname => a).italia.to_s
    elsif b==9 #포르투갈어
      return Menulist.find_by(:kname => a).portugal.to_s
    end  
  end
  
  def checkexist(kname,tid)
    search=Menulist.find_by(:kname => kname)
    #한글 이름이 아예 저장이 안되어있으면 nil 반환
    if search==nil
      return nil
    elsif tid==4#한국어
      return 1
    end
    
    #return 0은 번역이 있지만 해당 언어가 비어있거나 한국어일 경우
    #1은 번역이 있는 경우
    #nil은 번역 자체가 없는 경우
    
    if tid==0 #영어
      if search.ename.to_s.strip==""||search.ename.to_s.strip==kname
        return 0
      else
        return 1
      end
    elsif tid==1#일본어
      if search.jnamea.to_s.strip==""||search.jnamea.to_s.strip==kname
        return 0
      else
        return 1
      end
    elsif tid==2#중국어 간체
      if search.cname.to_s.strip==""||search.cname.to_s.strip==kname
        return 0
      else
        return 1
      end
    elsif tid==3#중국어 번체
      if search.cnameb.to_s.strip==""||search.to_s.strip==kname
        return 0
      else
        return 1
      end
    elsif tid==5
      if search.aname.to_s.strip==""||search.aname.to_s.strip==kname
        return 0
      else
        return 1
      end
    elsif tid==6#스페인어
      if search.spanish.to_s.strip==""||search.spanish.to_s.strip==kname
        return 0
      else
        return 1
      end
    elsif tid==7#독일어
      if search.germany.to_s.strip==""||search.germany.to_s.strip==kname
        return 0
      else
        return 1
      end
    elsif tid==8#이탈리아어
      if search.italia.to_s.strip==""||search.italia.to_s.strip==kname
        return 0
      else
        return 1
      end
    elsif tid==9#포르투갈어
      if search.portugal.to_s.strip==""||search.portugal.to_s.strip==kname
        return 0
      else
        return 1
      end
    end
  end
  
  
  def makeingre(string,tid)
    returnvalue=[]
    string=string.strip()
    if string.index('(')!=nil
      string=string[1..-2]
    end
    
    string.split(',').each do |s|
      if s.index(';')!=nil
        mark=';'  
      else
        mark=':'
      end
      ingre=s.split(mark).first
      existvalue=checkexist(ingre,tid)
      if existvalue==0
        returnvalue.append(ingre)
      elsif existvalue==1
        returnvalue.append(transout(ingre,tid))
      else
        returnvalue.append(ingre)
        new_menu(ingre)
      end
    end
    return returnvalue  
  end
  
  def isint(str)
    
    i=Integer(str) 
    return i 
    rescue 
    return nil
  end
  
  def spliter(xfood,tid)
    result_string=""
    if xfood.index("&")!=nil
      divide=xfood.split("&")
      result=[]
      divide.each do |d|
        judvar=checkexist(d,tid)
        if judvar==nil
          result.push(d)
          new_menu(d)
        elsif judvar==1
          result.push(transout(d,tid))
        else
          result.push(d)
        end
      end
      result_string=result.join("&")
    elsif xfood.index("/")!=nil
      divide=xfood.split("/")
      result=[]
      divide.each do |d|
        judvar=checkexist(d,tid)
        if judvar==nil
          result.push(d)
          new_menu(d)
        elsif judvar==1
          result.push(transout(d,tid))
        else
          result.push(d)
        end
      end
      result_string=result.join("/")
    else
      divide=xfood.split("-")
      result=[]
      divide.each do |d|
        judvar=checkexist(d,tid)
        if judvar==nil
          result.push(d)
          new_menu(d)
        elsif judvar==1
          result.push(transout(d,tid))
        else
          result.push(d)
        end
      end
      result_string=result.join("-")
    end
    
    return result_string
  end
  
  def how_like(xfood,order)
    #order가 1이면 증가시킴
    if xfood.index("&")!=nil
       divide=xfood.split("&")
       
    elsif xfood.index("/")!=nil
       divide=xfood.split("/")
    else
       divide=xfood.split("-")
    end
    result=Menulist.find_by(:kname => divide[0])
    if order==1
     
      result.u_like=result.u_like+1
      result.save
    end
    return result
  end
  
  
  def parsing_func(today)
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
        snack=snack.split()
        snack_form=""
        snack.each do|s|
          if s.index("(")!=nil
            snack_form=snack_form+"$"+s.strip
            
          end
        end
        Snack.new(:date => today,:menu => snack_form).save
      end
    end
    
    num=0
    humanity.each do |n|
      unless num==0 
      
        humanity_list=n.xpath("./td[@class='headerStyle']")
        
        if humanity_list.text.to_s[0..4]=="중식(1)"
          if Lunch1.find_by(:date => today)==nil
            #시간 저장
            lunch1=humanity_list.text.to_s[5..6]+":"+humanity_list.text.to_s[7..11]+":"+humanity_list.text.to_s[12..13]
            
            n.xpath("./td/table/tr/td").each do|x|
              if x.text!=""
                lunch1=lunch1+"$"+x.text
              end
            end
            Lunch1.new(:date => today,:menu =>lunch1).save
          end
        elsif humanity_list.text.to_s[0..4]=="중식(2)"
          if Lunch2.find_by(:date => today)==nil
            lunch2=humanity_list.text.to_s[5..6]+":"+humanity_list.text.to_s[7..11]+":"+humanity_list.text.to_s[12..13]
            n.xpath("./td/table/tr/td").each do|x|
              if x.text!=""
                lunch2=lunch2+"$"+x.text
              end
            end
            Lunch2.new(:date => today,:menu => lunch2).save
          end
        elsif humanity_list.text.to_s[0..4]=="중식(면)"
          if Lunchnoodle.find_by(:date =>today)==nil
            lunchnoodle= humanity_list.text.to_s[5..6]+":"+humanity_list.text.to_s[7..11]+":"+humanity_list.text.to_s[12..13]
            n.xpath("./td/table/tr/td").each do|x|
              if x.text!=""
                lunchnoodle=lunchnoodle+"$"+x.text
              end
            end
            Lunchnoodle.new(:date => today,:menu =>lunchnoodle).save
          end
        elsif humanity_list.text.to_s[0..1]=="조식"
          if Breakfast.find_by(:date =>today)==nil
            breakfast = humanity_list.text.to_s[2..3]+":"+humanity_list.text.to_s[4..8]+":"+humanity_list.text.to_s[9..10]
            n.xpath("./td/table/tr/td").each do|x|
              if x.text!=""
                breakfast=breakfast+"$"+x.text
              end
            end
            Breakfast.new(:date => today,:menu => breakfast).save
          end
        elsif humanity_list.text.to_s[0..1]=="석식"
          if Dinner.find_by(:date =>today)==nil
            dinner= humanity_list.text.to_s[2..3]+":"+humanity_list.text.to_s[4..8]+":"+humanity_list.text.to_s[9..10]
            n.xpath("./td/table/tr/td").each do|x|
              if x.text!=""
                dinner=dinner+"$"+x.text
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
        
        if faculty_list.text.to_s[0..1]=="중식"
          if Flunch.find_by(:date => today)==nil
            flunch = faculty_list.text.to_s[2..3]+":"+faculty_list.text.to_s[4..8]+":"+faculty_list.text.to_s[9..10]
            n.xpath("./td/table/tr/td").each do|x|
              if x.text!=""
                flunch=flunch+"$"+x.text
              end
            end
            Flunch.new(:date => today, :menu =>flunch).save
          end
        elsif faculty_list.text.to_s[0..1]=="석식"
          if Fdinner.find_by(:date => today)==nil
            fdinner= faculty_list.text.to_s[2..3]+":"+faculty_list.text.to_s[4..8]+":"+faculty_list.text.to_s[9..10]
            n.xpath("./td/table/tr/td").each do|x|
              if x.text!=""
                fdinner=fdinner+"$"+x.text
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
                menua=menua+"$"+x.text
              end
            end
            Menua.new(:date => today,:menu =>menua).save
          end
        elsif sky_list.text.to_s[0..2]=="메뉴B"
          if Menub.find_by(:date =>today)==nil
            menub=sky_list.text.to_s[3..4]+":"+sky_list.text.to_s[5..9]+":"+sky_list.text.to_s[10..11]
            n.xpath("./td/table/tr/td").each do|x|
              if x.text!=""
                menub=menub+"$"+x.text
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
  
  def ohomecookie
    if params[:language]==nil
      
      if cookies[:my_ohome_language]==nil
        
        if cookies[:my_language]==nil
          
          @language="4"
          
        else
          
          if cookies[:my_language]=="4"
            @language=cookies[:my_language]
          else
            @language="0"
          end
          
        end
        cookies.permanent[:my_ohome_language]=@language
      else
        
        @language=cookies[:my_ohome_language]
        
      end
      
    else
      @language=params[:language]
      cookies.permanent[:my_ohome_language]=@language
    end
  end
end
