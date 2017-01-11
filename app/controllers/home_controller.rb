require 'Parser'
require 'Stringfy'

class HomeController < ApplicationController
  include Parser
  include Stringfy
  
  before_action :banned_user
  
  def like
    id=params[:id]
    @menu=Menulist.find(id)
    if cookies[@menu.kname.to_sym]=="1"||session[@menu.kname.to_sym]=="1"#좋아요
      cookies[@menu.kname.to_sym]={value: 0, expires: 14.days.from_now }
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
      cookies[@menu.kname.to_sym]={value: 1, expires: 14.days.from_now}
      if cookies[@menu.kname.to_sym]!="1"
        session[@menu.kname.to_sym]=1
      end
      @menu.save
    end
    respond_to do |format|
      format.json { render :json => { :like => @menu.u_like } }
    end
  end
  
  def newadmin
    if Admin.find_by(:email => ENV["ADMIN_ID"])==nil
      admin=Admin.new
      admin.email=ENV["ADMIN_ID"]
      admin.password=ENV["ADMIN_PASS"]
      admin.save
      redirect_to "/"
    elsif Admin.find_by(email: ENV["CAF_ID"])==nil
      Admin.new(email: ENV['CAF_ID'],password: ENV['CAF_PWD']).save
      redirect_to "/"
    else
      redirect_to :back
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
    @date=time.strftime("%A")
    # #요일
    @w=time.wday
    #선택한 날짜
    @y=time.year
    @d=time.day
    @m=time.month
    
    #아예 처음이면
    
    check=Lunch1.find_by(date: @day)
    checkf=Flunch.find_by(date: @day)
    checks=Menua.find_by(date: @day)
    begin
      if @w==0
        r_all=Rest.all
        len=r_all.length
        begin
        seed_id=rand(0..len-1)
        @ran_rest=r_all[seed_id]
        rescue
        @ran_rest=nil
        end
      elsif check==nil||checkf==nil||checks==nil
        parsing_func(@day)
      end
    rescue Exception => e
    puts e.message
    end
    @menulist=[Breakfast,Lunch1,Lunch2,Lunchnoodle,Dinner,Snack,Flunch,Fdinner,Menua,Menub].map{|data| make_list(data,@day,@id)}
  end
  
  
end

# developer mail address lsrock1@naver.com