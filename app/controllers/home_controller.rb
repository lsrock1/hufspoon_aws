require 'Parser'
require 'Getlist'

class HomeController < ApplicationController
  include Parser
  include Getlist
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
    @hashData=languageHash()
    @languageHash=@hashData.except(@id)
    #루트로 접속하면 번역은 0이고 데이는 nil이 된다
    if @id==0&&@day==nil
      if cookies[:my_language]!=nil
        @id=cookies[:my_language].to_i
      end
    end
    cookies.permanent[:my_language]=@id
   
   
    begin
      @time=Date.parse(@day)#get 파라미터로 날짜를 분석
    rescue
      @time=Time.new.in_time_zone("Seoul")#실패하면 오늘 날짜를 타임존에서 꺼내온다
    end
    @d=@time.day
    @m=@time.month
    dd = @d<10 ? '0'+@d.to_s : @d.to_s
    mm=@m<10 ? '0'+@m.to_s : @m
    
    @day=@time.year.to_s+mm.to_s+dd.to_s #오늘날짜를 yyyymmdd로 합친다
    @time=@time.class.name == 'Date' ? @time : Date.parse(@day) #오늘날짜를 타임존에서 꺼내왔을 경우 time 객체라서 날짜연산이 부정확하므로 다시 date 객체로 변환한다.
    
    @date=@time.strftime("%a").upcase #요일
    @w=@time.wday #숫자로 나타낸 요일
    
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
      elsif @w==6&&check==nil
        parsing_func(@day)
      elsif check==nil||checkf==nil||checks==nil
        parsing_func(@day)
      end
    rescue Exception => e
    puts e.message
    end
    @menulist=[Breakfast,Lunch1,Lunch2,Lunchnoodle,Dinner,Snack,Flunch,Fdinner,Menua,Menub].map do |data|
      data.make_list(@day,@id)
    end
  end
  
  
end

# developer mail address lsrock1@naver.com