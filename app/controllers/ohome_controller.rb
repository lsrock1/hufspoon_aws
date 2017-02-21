require 'Getlist'
class OhomeController < ApplicationController
  before_action :banned_user, randomToken, :ohomecookie, except: [:search]
  
  include Getlist
  
  def show
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
      @menuarray.append(@rest.rmenu.where(pagenum: d).order('created_at ASC'))
    end
    @num=@menuarray.length
    @picture_exist=@rest.rmenu.select{|item| !item.picture.blank?}
    restCategoryHash=restCategoryHash().map{|key,value| value[0]}
    @back=params[:index] ? -1 : restCategoryHash.index(@rest.food)
  end
  
  def index
    @search=true
    @num=params[:num] ? params[:num].to_i : 0 #음식종류별 화면
    @all=[]
    @list=[]
    @restCategoryHash=restCategoryHash
    @restCategoryHash[@num].append("active")
    @languageHash=oLanguageHash.except(@language)
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
    
    @list=Rest.where(food: categoryName).sort_by{|a| a.name}
    
    render layout: 'home'
  end
  
  def search
    @keyword=params[:keyword]
    @back=params[:back]
    all=Rmenu.where("menuname like ?", "%" + @keyword + "%")
    result=all.map {|i| i.rest_id }
    result=result.uniq
    @rest=Rest.includes(:rmenu).where("name like ?","%"+@keyword+"%")
    @result=Rest.includes(:rmenu).where(id: result)

    if @rest.length==0&&@result.length==0
      all=Rmenu.where("emenuname like ?", "%" + @keyword + "%")
      result=all.map {|i| i.rest_id }
      result=result.uniq
      @result=Rest.includes(:rmenu).where(id: result)
    end
  end
  
  private
    def ohomecookie
      if params[:language]==nil
        #언어가 URI로 설정되지 않는다면
        if cookies[:my_ohome_language]==nil
          #쿠키에 ohome 설정이 없다면
          if cookies[:my_language]==nil
            #home 언어 설정이 없으면
            @language=4
          else
            #home 언어 설정이 있으면 그것을 쓴다
            if cookies[:my_language]=="4"
              @language=4
            elsif cookies[:my_language]=="2"
              @language=2
            else
              @language=0
            end
          end
          cookies.permanent[:my_ohome_language]=@language
        else
          #쿠키에 ohome 설정이 있으면 그것을 사용한다
          @language=cookies[:my_ohome_language].to_i
        end
      else
        #언어가 URI로 설정되면
        if params[:language]=="4"
          @language=4
        elsif params[:language]=="2"
          @language=2
        else
          @language=0
        end
        cookies.permanent[:my_ohome_language]=@language
      end
    end
end
