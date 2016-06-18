class OadpageController < ApplicationController
  before_action :require_login
     ###################일반식단 관리 클래스들######################
  def dbmain
    @map=Map.all
  end
  
  #식당 추가
  def addrest
    find=Map.where(lat: params[:lat].to_f,lon: params[:lon].to_f)
    
    if find.length==1
      find=Map.find_by(lat: params[:lat].to_f,lon: params[:lon].to_f)
      if Rest.find_by(map_id: find.id.to_i,name: params[:name])!=nil
        redirect_to :back
      else
        nrs=Rest.new
        nrs.map_id=find.id.to_i
        nrs.name=params[:name]
        nrs.food=params[:food]
        nrs.save
        redirect_to :back
      end
    else
      nm=Map.new
      nm.lat=params[:lat].to_f
      nm.lon=params[:lon].to_f
      nm.save
      nrs=Rest.new
      nrs.map_id=nm.id
      nrs.name=params[:name]
      nrs.food=params[:food]
      nrs.save
      redirect_to :back
    end
    
  end
  
  #식당 삭제
  def delrest
    drest=Rest.find(params[:id])
    dmap=Map.find(drest.map_id)
    if dmap.rests.length>=2
      allmenu=Rmenu.where(:rest_id => drest.id)
      allmenu.each do|i|
        i.destroy
      end
      drest.destroy
    else
      allmenu=Rmenu.where(:rest_id => drest.id)
      allmenu.each do|i|
        i.destroy
      end
      dmap.destroy
      drest.destroy
    end
    redirect_to :back
  end
  
  def addmenu_page
    @rest=Rest.find(params[:id])
  end
  
  def addmenu
    #kname이 없을 경우(즉, 번역이 존재해서 메뉴가 곧바로 저장될 경우)
    if params[:kname]==nil
      if Menulist.find_by(:kname => params[:menuname])==nil
        @menuname=params[:menuname]
        @content=params[:content]
        @id=params[:id]
      else
        newmenu=Rmenu.new
        newmenu.rest_id=params[:id]
        newmenu.content=params[:content]
        newmenu.menuname=params[:menuname]
        newmenu.save
        redirect_to '/oadpage/addmenu_page/'+params[:id]
      end
    #번역까지 저장 시
    else
      newtrans=Menulist.new
      newtrans.kname=params[:kname]
      newtrans.ername=params[:ername]
      newtrans.ename=params[:ename]
      newtrans.save
      newmenu=Rmenu.new
      newmenu.rest_id=params[:id]
      newmenu.content=params[:content]
      newmenu.menuname=params[:kname]
      newmenu.save
      redirect_to '/oadpage/addmenu_page/'+params[:id]
    end
  end
  #식당 수정
  def rewriterest
    drest=Rest.find(params[:id])
    dmap=Map.find(drest.map_id)
    if dmap.rests.length>=2
      nm=Map.new
      nm.lat=params[:lat].to_f
      nm.lon=params[:lon].to_f
      nm.save
      nmid=nm.id
      drest.name=params[:name]
      drest.food=params[:food]
      drest.map_id=nmid
      drest.save
    else
      dmap.lat=params[:lat].to_f
      dmap.lon=params[:lon].to_f
      dmap.save
      drest.name=params[:name]
      drest.food=params[:food]
      drest.save
    end
    redirect_to :back
  end
  
  #식당 메뉴 삭제 클래스
  def delmenu
    del=Rmenu.find(params[:id])
    id=del.rest_id
    del.destroy
    redirect_to "/oadpage/addmenu_page/"+id.to_s
  end
end
