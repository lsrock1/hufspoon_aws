class OhomeController < ApplicationController
  before_action :ohomecookie, except: [:search]
  
  def rightindex
    
    
    @menuarray=[]
    id=params[:id]
    @rest=Rest.find(id)
    @map=Map.find(@rest.map_id)
    begin
      @pages=@rest.page.split(",")
    rescue
      @pages=nil
    end
    menupage=@rest.rmenu.map{|m| m.pagenum}
    menupage=menupage.uniq
    menupage.delete(0)
    menupage.each do |d|
      @menuarray.append(@rest.rmenu.where(:pagenum => d).order('created_at ASC'))
    end
    @num=@menuarray.length
    if params[:index].to_i==1
      @back=-1 #최초페이지로 돌아감
    elsif @rest.food=="한식"
      @back=0
    elsif @rest.food=="일식"
      @back=1
    elsif @rest.food=="양식"
      @back=2
    elsif @rest.food=="중식"
      @back=3
    elsif @rest.food=="치킨"
      @back=4
    elsif @rest.food=="고기"
      @back=5
    else
      @back=6
    end
  end
  
  def index
    
    
    @one=Curate.find_by(:show => "1")
    @two=Curate.find_by(:show => "2")
    @three=Curate.find_by(:show => "3")
    @four=Curate.find_by(:show => "4")
    @five=Curate.find_by(:show => "5")
    @six=Curate.find_by(:show => "6")
  end
  
  def leftindex
    
    
    @num=params[:num] #음식종류별 화면
    @all=[]
    if @num=="0" #korean
      n="한식"
    elsif @num=="1" #japanese
      n="일식"
    elsif @num=="2" #western
      n="양식"
    elsif @num=="3" #chinese
      n="중식"
    elsif @num=="4"
     n="치킨"
    elsif @num=="5"
    n="고기"
    elsif @num=="6"
     n="분식/면"
    end
    
    Map.all.each do|m|
     temp=[]
     string=[]
     restaurants=m.rests.where(:food => n)
     if restaurants.length>0 #한식,중식,일식으로 레스토랑 검색
       temp.append(m.lat)
       temp.append(m.lon)
       restaurants.each do|e|
        string.append(e)
       end
       temp.append(string)
       @all.append(temp)
     end
    end
    


    
  end
  
  def search
    @keyword=params[:keyword]
    @back=params[:back]
    all=Rmenu.where("menuname like ?", "%" + @keyword + "%")
    result=all.map {|i| i.rest_id }
    result=result.uniq
    @rest=Rest.where("name like ?","%"+@keyword+"%")
    @result=Rest.where(id: result)
    
    if @rest.length==0&&@result.length==0
      all=Rmenu.where("emenuname like ?", "%" + @keyword + "%")
      result=all.map {|i| i.rest_id }
      result=result.uniq
      @result=Rest.where(id: result)
    end
  end
  
  
end
