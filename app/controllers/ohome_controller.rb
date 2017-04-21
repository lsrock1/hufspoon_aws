require 'Getlist'
class OhomeController < ApplicationController
  before_action :banned_user, :randomToken, :ohomecookie, except: [:search]
  
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
    @back = params[:index]
  end
  
  def index
    @category = Hash.new{ |hash, key| hash[key] = Array.new }
    @rest = Rest.all.sort_by{|a| a.name}
    @rest.each do |rest|
      @category[rest.food].append(rest)
    end
    @categoryKeys = @category.keys
    if @categoryKeys.length < 8
      @categoryKeys.concat(Array.new(8 - @categoryKeys.length))
    end
    @map = Hash.new{ |hash, key| hash[key] = Array.new }

    @restCategoryHash = restCategoryHash
    @languageHash = oLanguageHash
    @current_language = @languageHash[@language]["dataTransName"]
  end

  def search
    @q = params[:q]
    language = params[:language]
    
    collection = []
    map = {@q => []}
    rests = Rest.search(@q).sort_by{|a| a.name}
    rests.each do |rest|
      data = {
        name: rest.name, 
        category: rest.food,
        id: rest.id,
        picture: rest.picture
      }
      if rest.name.include? @q or rest.food.include? @q
        if language == "english"
          data[:english] = rest.ere_menu
        elsif language == "korean"
          data[:korean] = rest.re_menu
        else
          data[:chinese] = rest.chinese
        end
      else
        temp = rest.rmenu.where("lower(menuname) like ? or lower(emenuname) like ? or lower(cmenuname) like ?","%#{@q.to_s.downcase}%","%#{@q.to_s.downcase}%","%#{@q.to_s.downcase}%").order(:pagenum)
        if temp.length > 0
          if temp[0].menuname.downcase.include? @q.downcase
            data[:korean] = temp[0].menuname.downcase
          elsif temp[0].emenuname.downcase.include? @q.downcase
            data[:english] = temp[0].emenuname.downcase
          else
            data[:chinese] = temp[0].cmenuname.downcase
          end
        end
      end
      collection.push(data)
      map[@q].push({id: rest.id, name: rest.name, lat: rest.map.lat, lon: rest.map.lon})
    end
    respond_to do |format|
      format.json { render :json => [collection, map] }
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
