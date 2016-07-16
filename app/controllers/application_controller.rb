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
    
    nmenu=Menulist.new(:kname => a,:ename => a,:ername => a, :jnamea => a,:cname => a,:cnameb => a,:aname => a)
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
    else #아랍어
      return Menulist.find_by(:kname => a).aname.to_s
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
    else
      if search.aname.to_s.strip==""||search.aname.to_s.strip==kname
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
  
  
end
