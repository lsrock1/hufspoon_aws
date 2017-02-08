class Data::DietsController < ApplicationController
  before_action :require_login
  layout 'data'
  
  def index
    @day=params[:day]
    begin
      @time=Date.parse(@day)#get 파라미터로 날짜를 분석
    rescue
      @time=Time.new.in_time_zone("Seoul")#실패하면 오늘 날짜를 타임존에서 꺼내온다
    end
    dd = @time.day < 10 ? '0' + @time.day.to_s : @time.day.to_s
    mm = @time.month < 10 ? '0' + @time.month.to_s : @time.month
    
    @day = @time.year.to_s + mm.to_s + dd.to_s #오늘날짜를 yyyymmdd로 합친다
    @menulist=[Breakfast,Lunch1,Lunch2,Lunchnoodle,Dinner,Flunch,Fdinner,Menua,Menub].map{|data| [data.getname,data.find_by(date: @day)]}
  end
  
  def edit
  
  end
end
