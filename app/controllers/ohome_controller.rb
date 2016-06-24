class OhomeController < ApplicationController
  def rightindex
    @id=params[:id]
    @num=params[:num]
    @lat=params[:lat]
    @lon=params[:lon]
    unless @id=="0"
      @re=Rest.find(@id)
    end
  end
  
  def leftindex
    @dis=params[:dis]
    @num=params[:num] #음식종류별 화면
    @lat=params[:lat] #위도
    @lon=params[:lon] #경도
    @all=[]
    if @num=="1" #korean
      n="한식"
    elsif @num=="2" #japanese
      n="일식"
    elsif @num=="3" #western
      n="양식"
    elsif @num=="4" #chinese
      n="중식"
    end
    Map.all.each do|m|
     temp=[]
     string=[]
     if m.rests.where(:food => n).length>0
       temp.append(m.lat)
       temp.append(m.lon)
       m.rests.where(:food => n).each do|e|
        string.append([e.id,e.name])
       end
       temp.append(string)
       @all.append(temp)
     end
     
    
    end
    
    
      
  end
end
