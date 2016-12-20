class OadpageController < ApplicationController
  before_action :require_login
     ###################일반식당 관리 클래스들######################
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
      newtrans.spanish=params[:spanish]
      newtrans.germany=params[:germany]
      newtrans.italia=params[:italia]
      newtrans.portugal=params[:portugal]
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
  
  def excel
  end
  
  def get_excel
    workbook = WriteXLSX.new('public/public/rest_menu.xlsx')
    worksheet = workbook.add_worksheet
    
    num=0
    Map.all.each do|a|
      worksheet.write(num,0,"map")
      worksheet.write(num,1,a.lat)
      worksheet.write(num,2,a.lon)
      num+=1
      a.rests.each do |b|
        worksheet.write(num,0,"rest")
        worksheet.write(num,1,b.name)
        worksheet.write(num,2,b.food)
        worksheet.write(num,3,b.page)
        worksheet.write(num,4,b.picture)
        worksheet.write(num,5,b.re_menu)
        worksheet.write(num,6,b.ere_menu)
        worksheet.write(num,7,b.address)
        worksheet.write(num,8,b.phone)
        worksheet.write(num,9,b.open)
        num+=1
        b.rmenu.each do |c|
          worksheet.write(num,0,"menu")
          worksheet.write(num,1,c.menuname)
          worksheet.write(num,2,c.emenuname)
          worksheet.write(num,3,c.content)
          worksheet.write(num,4,c.cost)
          worksheet.write(num,5,c.category)
          worksheet.write(num,6,c.pagenum)
          num+=1
        end
      end
    end
      workbook.close
    send_file 'public/public/rest_menu.xlsx', :type=>"application/xlsx", :x_sendfile=>true
  end
  
  def put_excel
    if params[:ex]==nil
      redirect_to :back
    else
      if params[:ex].original_filename.to_s.split(".")[1]!="xlsx"
        redirect_to :back
      else
      newfile=MangoUploader.new
      newfile.store!(params[:ex])
      newmap=0
      newrest=0
      xlsx = Roo::Spreadsheet.open('public/public/down.xlsx')
      sheet1 = xlsx.sheet(0)
        sheet1.each do |s|
          unless (s[0].to_s=="")
            if s[0].to_s=="map"
              if Map.where(lat: s[1].to_s,lon: s[2].to_s).length == 0
                newmap=Map.new(lat: s[1].to_s,lon: s[2].to_s)
                newmap.save
              else
                newmap=Map.find_by(lat: s[1].to_s,lon: s[2].to_s)
              end
            elsif s[0].to_s=="rest"
              if newmap.rests.where(name: s[1].to_s).length==0
                newrest=Rest.new(map_id: newmap.id,name: s[1].to_s,food: s[2].to_s,page: s[3].to_s,picture: s[4].to_s,re_menu: s[5].to_s,ere_menu: s[6].to_s,address: s[7].to_s,phone: s[8].to_s,open: s[9].to_s)
                newrest.save
              else
                newrest=Rest.find_by(name: s[1].to_s)
              end
            elsif s[0].to_s=="menu"
              if newrest.rmenu.where(menuname: s[1].to_s).length==0
                Rmenu.new(rest_id: newrest.id,menuname: s[1].to_s,emenuname: s[2].to_s,content: s[3].to_s,cost: s[4].to_s,category: s[5].to_s,pagenum: s[6].to_s).save
              end
            end
          end
        end
      redirect_to :back
      end
      
    end
  end
  
  
end
