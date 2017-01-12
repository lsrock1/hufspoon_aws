class OhomeController < ApplicationController
  before_action :banned_user,:ohomecookie, except: [:search]
  
  def show
    @search=true
    @search_page=true
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
    menupage.sort!
    menupage.each do |d|
      @menuarray.append(@rest.rmenu.where(:pagenum => d).order('created_at ASC'))
    end
    @num=@menuarray.length
    if params[:index]
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
    @search=true
    @num=params[:num] ? params[:num] : "0" #음식종류별 화면
    @all=[]
    @list=[]
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
    
    Map.includes(:rests).all.each do|m|
     temp=[]
     string=[]
     restaurants=m.rests.where(food: n)
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
    
    @list=Rest.where(food: n).sort{|a,b| a.name <=> b.name}
  end
  
  def search
    @search=true
    @search_page=true
    @keyword=params[:keyword]
    @back=params[:back]
    all=Rmenu.where("menuname like ?", "%" + @keyword + "%")
    result=all.map {|i| i.rest_id }
    result=result.uniq
    @rest=Rest.includes(:rmenus).where("name like ?","%"+@keyword+"%")
    @result=Rest.includes(:rmenus).where(id: result)
    
    if @rest.length==0&&@result.length==0
      all=Rmenu.where("emenuname like ?", "%" + @keyword + "%")
      result=all.map {|i| i.rest_id }
      result=result.uniq
      @result=Rest.includes(:rmenus).where(id: result)
    end
  end
  
  private
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
