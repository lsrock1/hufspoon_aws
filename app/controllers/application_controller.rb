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
  
  def banned_user
    if cookies[:post]
      cookies[:post].split(",").each do |id|
        if Banned.find_by(identity: "post",number: id)!=nil
          redirect_to 'https://meta.wikimedia.org/wiki/Banned_user'
        end
      end
    elsif cookies[:comment]
      cookies[:comment].split(",").each do |id|
        if Banned.find_by(identity: "comment",number: id)!=nil
          redirect_to 'https://meta.wikimedia.org/wiki/Banned_user'
        end
      end
    end
    
    if Banned.find_by(identity: "ip",ip: request.remote_ip)!=nil
      redirect_to 'https://meta.wikimedia.org/wiki/Banned_user'
    end
  end
  
  def make_list data,day,id
    menu_data=data.find_by(date: day)
    innum=0
    ingre=[]
    
    unless menu_data==nil
      menu_list=[]
      kcal=nil
      price=nil
      main=nil
      
      menu_data=menu_data.menu.split("$")
      
      if data.getname=='Lunch 1'||data.getname=='Lunch 2'||data.getname=='dinner'||data.getname=='Breakfast'||data.getname=='Lunch Noodles'
        time=menu_data.shift
        menu_data.each do |l|
          if l.index(':')!=nil
            ingre.concat(makeingre(l,id))
          elsif l[-1]=="l"
            kcal=l
          elsif l[-1]=="원"
            price=l[0..-2]+"won"
          else
            xfood=l.strip
            menu_list.push(Menulist.gettrans(xfood,id))
            if innum==0
              main=Menulist.find_by(:kname => xfood)
            end
          end
            
          innum=1+innum
        end
      elsif data.getname=='Snack'
        time='09:00~18:40'
          menu_data.each do|s|
            if s.index("(")!=nil
              s=s.strip
              s=s.gsub('*', '')
              s=s.sub("원"," won")
              sfirst=s.index("(")-1
              food=s[0..sfirst]
              food=food.split("/")
              
              
              food.each do |f|
                temp=Menulist.gettrans(f,id)
                menu_list.push(temp+" "+s[sfirst+1..-1])
              end
              
            end
          end
        
      else
        
        time=menu_data.shift
        menu_data.each do |l|
          if l[-1]=="l"
            kcal=l
          elsif l[-1]=="원"
            price=l[0..-2]+" won"
          else
            if l.index("(")!=nil
              xfirst=l.index("(")
              xfood=l[0..(xfirst-1)].strip
              ingre.concat(makeingre(l[xfirst..-1],id))
            else
              xfood=l.strip
            end
            
            #메뉴가 이상한 문자로 엮여있을 경우
            if xfood.index("&")!=nil||xfood.index("/")!=nil||xfood.index("-")!=nil
              menu_list.push(spliter(xfood,id))
              if innum==0
                main=extract(xfood)
              end
            else
              
              menu_list.push(Menulist.gettrans(xfood,id))
              if innum==0
                main=Menulist.find_by(:kname => xfood)
              end
            end
          end
          innum=1+innum
        end
        
      end
    end
    return {
      'name' => data.getname,
      'time' => time,
      'kcal' => kcal,
      'price' => price,
      'ingre' => ingre.uniq,
      'menu' => menu_list,
      'main' => main
    }
  end
  
  def makeingre string,tid
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
      returnvalue.append(Menulist.gettrans(ingre,tid))
    end
    if returnvalue==[]
      return nil
    else
      return returnvalue
    end
  end
  
  def isint(str)
    
    i=Integer(str) 
    return i 
    rescue 
    return nil
  end
  
  def spliter xfood,tid
    result_string=""
    ['&','/','-'].each do |word|
      if xfood.index(word)!=nil
        divide=xfood.split(word)
        result=[]
        divide.each do |d|
          result.push(Menulist.gettrans(d,tid))
        end
        result_string=result.join(word)
      end
    end
    return result_string
  end
  
  def extract xfood
    
    if xfood.index("&")!=nil
       divide=xfood.split("&")
       
    elsif xfood.index("/")!=nil
       divide=xfood.split("/")
    else
       divide=xfood.split("-")
    end
    result=Menulist.find_by(:kname => divide[0])
    return result
  end
  
  
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
  
  
end
