require 'Getlist'
class OhomeController < ApplicationController
  before_action :banned_user,:ohomecookie, except: [:search]
  include Getlist
  
  def show
    @search=true
    @search_page=true
    @menuarray=[]
    id=params[:id]
    @rest=Rest.includes(:rmenu).find(id)
    @map=Map.find(@rest.map_id)
    begin
      @pages=@rest.page.split(",")
    rescue
      @pages=nil
    end
    menupage=@rest.rmenu.map{|m| m.pagenum}
    menupage.uniq!
    menupage.delete(0)
    menupage.sort!
    menupage.each do |d|
      @menuarray.append(@rest.rmenu.where(:pagenum => d).order('created_at ASC'))
    end
    @num=@menuarray.length
    
    restCategoryHash=restCategoryHash().map{|key,value| value[0]}
    @back=restCategoryHash.index(@rest.food) ? restCategoryHash.index(@rest.food) : -1
  end
  
  def index
    @search=true
    @num=params[:num] ? params[:num].to_i : 0 #음식종류별 화면
    @all=[]
    @list=[]
    @restCategoryHash=restCategoryHash
    @restCategoryHash[@num].append("active")
    
    categoryName=@restCategoryHash[@num][0]
    
    Map.includes(:rests).all.each do|m|
     temp=[]
     string=[]
     restaurants=m.rests.where(food: categoryName)
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
    
    @list=Rest.where(food: categoryName).sort{|a,b| a.name <=> b.name}
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
            
            @language=4
            
          else
            
            if cookies[:my_language]=="4"
              @language=cookies[:my_language].to_i
            else
              @language=0
            end
            
          end
          cookies.permanent[:my_ohome_language]=@language
        else
          
          @language=cookies[:my_ohome_language].to_i
          
        end
        
      else
        @language=params[:language].to_i
        cookies.permanent[:my_ohome_language]=@language
      end
    end
end
