class OadpageController < ApplicationController
  before_action :require_login
     ###################일반식단 관리 클래스들######################
  def dbmain
    @map=Map.all
  end
  
  def rest_re
    @rest=Rest.find(params[:id])
    @map=Map.find(@rest.map_id)
  end
  
  def rest_add
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
        nrs.address=params[:add]
        nrs.phone=params[:pho]
        nrs.picture=params[:picture]
        nrs.open=params[:open]
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
      nrs.address=params[:add]
      nrs.phone=params[:pho]
      nrs.picture=params[:picture]
      nrs.open=params[:open]
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
        @cost=params[:cost]
        @backid=params[:backid]
        @pagenum=params[:pagenum]
      else
        newmenu=Rmenu.new
        newmenu.rest_id=params[:backid]
        newmenu.content=params[:content]
        newmenu.menuname=params[:menuname]
        newmenu.cost=params[:cost]
        newmenu.pagenum=params[:pagenum]
        newmenu.emenuname=Menulist.find_by(:kname => params[:menuname]).ename
        newmenu.save
        if params[:pagenum].to_i==0
          re=Rest.find(params[:backid])
          re.re_menu=params[:menuname]
          re.ere_menu=newmenu.emenuname
          re.save
        end
        redirect_to '/oadpage/addmenu_page/'+params[:backid]
      end
    #번역까지 저장 시
    else
      newtrans=Menulist.new
      newtrans.kname=params[:kname]
      newtrans.ername=params[:ername]
      newtrans.ename=params[:ename]
      newtrans.jnamea=params[:jnamea]
      newtrans.cname=params[:cname]
      newtrans.cnameb=params[:cnameb]
      newtrans.aname=params[:aname]
      newtrans.save
      newmenu=Rmenu.new
      newmenu.rest_id=params[:backid]
      newmenu.content=params[:content]
      newmenu.emenuname=params[:ename]
      newmenu.menuname=params[:kname]
      newmenu.cost=params[:cost]
      newmenu.pagenum=params[:pagenum]
      newmenu.save
      if params[:pagenum].to_i==0
        re=Rest.find(params[:backid])
        re.re_menu=params[:kname]
        re.ere_menu=params[:ename]
        re.save
      end
      redirect_to '/oadpage/addmenu_page/'+params[:backid]
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
      drest.picture=params[:picture]
      drest.address=params[:add]
      drest.phone=params[:pho]
      drest.open=params[:open]
      drest.map_id=nmid
      drest.save
    else
      dmap.lat=params[:lat].to_f
      dmap.lon=params[:lon].to_f
      dmap.save
      drest.name=params[:name]
      drest.food=params[:food]
      drest.picture=params[:picture]
      drest.address=params[:add]
      drest.phone=params[:pho]
      drest.open=params[:open]
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
  
  def rewritemenu
    if Menulist.find_by(:kname => params[:menuname])==nil
      redirect_to :back
    else
    remenu=Rmenu.find(params[:id])
    remenu.menuname=params[:menuname]
    remenu.emenuname=Menulist.find_by(:kname => params[:menuname]).ename
    remenu.content=params[:content]
    remenu.cost=params[:cost]
    remenu.pagenum=params[:pagenum]
    remenu.save
    if params[:pagenum].to_i==0
      re=Rest.find(remenu.rest_id)
      re.re_menu=params[:menuname]
      re.ere_menu=remenu.emenuname
      re.save
    end
    redirect_to "/oadpage/addmenu_page/"+params[:backid]
    end
    
  end
  
  def page
    r=Rest.find(params[:id])
    r.page=params[:page]
    r.save
    redirect_to :back
  end
  
  def show_config
    all_pi=Curate.all
    @id=params[:id].to_i
    @num=(all_pi.length/10)+1
    if @id==0
      instance=[]
      all_pi.each do |i|
        if i.show.to_s!="0"
          instance.push(i)
        end
      end
      @all=instance
    else
      @all=all_pi.all.order('created_at DESC')[(@id-1)*10..10*(@id)-1]
    end
  end
  
  def show_add
    
  end
  
  def image_add
    Curate.new(:address => params[:address],:keyword => params[:keyword]).save
    redirect_to '/oadpage/show/1'
  end
  
  def image_del
    Curate.find(params[:id]).destroy
    redirect_to :back
  end
  
  
  
  def image_show
    if params[:show].to_i>6||params[:show].to_i<0
      redirect_to :back
    elsif params[:show].to_i==0  
      conf=Curate.find(params[:id])
      conf.show=params[:show]
      conf.save
      redirect_to :back
    elsif Curate.find_by(:show => params[:show])==nil
      conf=Curate.find(params[:id])
      conf.show=params[:show]
      conf.save
      redirect_to :back
    else
      redirect_to :back
    end
  end
end
