class AdpageController < ApplicationController
  before_action :require_login
  #########db관리메인페이지##################
  def dbmain
    instance=[]
    
    @info=params[:id]
    @list=Menulist.all
    unless @info.to_i==1
      @list.each do|l|
        if l.kname==l.ename
          instance.push(l)
        end
      end
     @list=instance
    end
     
    
  end
  
  def dbmain2
  @map=Map.all
  end
  
  def rewrite
    id=params[:id]
    @info=params[:info]
    @re_menu=Menulist.find(id)
  end
  
  #################메뉴 관리 클래스####################
  #메뉴를 삭제하는 페이지
  def delmenu
    delmenu=Menulist.find(params[:id])
    delmenu.destroy
    redirect_to :back
  end

  #메뉴를 저장하는 페이지, 메뉴가 이미 존재하면 존재하는 메뉴를 보여줌
  def existmenu
    @info=params[:info]
    #메뉴가 존재하면 그 메뉴를 찾아서 보여준다
    if Menulist.find_by(:kname => params[:kname])!=nil
      @ex_menu=Menulist.find_by(:kname => params[:kname])
    #메뉴가 존재하지 않으면 저장하되 안전성검사를 거친다   
    else  
      #이름과 영어 뜻 중 하나라도 비어있으면 저장하지 않는다
      if (params[:kname]=="")||(params[:ename]=="")
        redirect_to :back
      #아닐 경우 저장하고 원래 페이지로 되돌아간다
      else
      newmenu=Menulist.new
      newmenu.kname=params[:kname]
      newmenu.ename=params[:ename]
      newmenu.ername=params[:ername]
      newmenu.save
        redirect_to :back
      end
    end
  
  end
  
  #메뉴 수정 페이지
  def remenu
    if (params[:kname]=="")||(params[:ename]=="")
        redirect_to :back
    else
    remenu=Menulist.find(params[:id])
    remenu.kname=params[:kname]
    remenu.ename=params[:ename]
    remenu.ername=params[:ername]
    remenu.save
        if params[:info].to_i==1
          redirect_to "/insertmenu/1"
        else
          redirect_to "/insertmenu/2"
        end
    end
  end
  
  ###################일반식단 관리 클래스들######################
  #일반식당 추가 페이지
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
  
  def delrest
    drest=Rest.find(params[:id])
    dmap=Map.find(drest.map_id)
    if dmap.rests.length>=2
      drest.destroy
    else
      dmap.destroy
      drest.destroy
    end
    redirect_to :back
  end
  
  def addmenu
    @rest=Rest.find(params[:id])
  end
  
  def insertmenu
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
        redirect_to '/adpage/addmenu/'+params[:id]
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
      redirect_to '/adpage/addmenu/'+params[:id]
    end
  end
  
  #식당 메뉴 삭제 클래스
  def delrmenu
    del=Rmenu.find(params[:id])
    id=del.rest_id
    del.destroy
    redirect_to "/adpage/addmenu/"+id.to_s
  end
  ###################엑셀 관련 클래스######################
  #db->엑셀
  def download
    workbook = WriteXLSX.new('public/down.xlsx')
    worksheet = workbook.add_worksheet
    
    num=0
    Menulist.all.each do|a|
      worksheet.write(num,0,a.kname)
      worksheet.write(num,1,a.ername)
      worksheet.write(num,2,a.ename)
      num=num+1
    end
      workbook.close
    send_file 'public/down.xlsx', :type=>"application/xlsx", :x_sendfile=>true
  end
  
  #엑셀->db
  def filesave
    if params[:ex]==nil
      redirect_to :back
    else
      if params[:ex].original_filename.to_s.split(".")[1]!="xlsx"
        redirect_to :back
      else
      newfile=MangoUploader.new
      newfile.store!(params[:ex])
      
      xlsx = Roo::Spreadsheet.open('public/public/db.xlsx')
      sheet1 = xlsx.sheet(0)
        sheet1.each do |s|
          unless (s[0].to_s=="")||(s[2].to_s=="")
            if Menulist.find_by(:kname => s[0])!=nil
              exme=Menulist.find_by(:kname => s[0])
              exme.ename=s[2]
              exme.ername=s[1]
              exme.save
            else
              
              newme=Menulist.new
              newme.kname=s[0]
              newme.ename=s[2]
              newme.ername=s[1]
              newme.save
              
            end
          end
        end
      redirect_to :back
      end
      
    end
  end
  
end
