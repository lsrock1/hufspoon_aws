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
    if Menulist.find_by(:kname =>a)==nil
    nmenu=Menulist.new(:kname => a,:ename => a,:ername => a, :jnamea => a,:cname => a,:cnameb => a,:aname => a)
    nmenu.save
    end
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
    else #아랍어
      return Menulist.find_by(:kname => a).aname.to_s
    end  
  end
  
  def checkexist(kname,tid)
    #한글 이름이 아예 저장이 안되어있으면 nil 반환
    if Menulist.find_by(:kname => kname)==nil
      return nil
    end
    
    if tid==0 #영어
      if Menulist.find_by(:kname => kname).ename.to_s.strip==""
        return nil
      else
        return 1
      end
    elsif tid==1#일본어
      if Menulist.find_by(:kname => kname).jnamea.to_s.strip==""
        return nil
      else
        return 1
      end
    elsif tid==2#중국어 간체
      if Menulist.find_by(:kname => kname).cname.to_s.strip==""
        return nil
      else
        return 1
      end
    elsif tid==3#중국어 번체
      if Menulist.find_by(:kname => kname).cnameb.to_s.strip==""
        return nil
      else
        return 1
      end
    else
      if Menulist.find_by(:kname => kname).aname.to_s.strip==""
        return nil
      else
        return 1
      end
    end
    
  end
  
end
