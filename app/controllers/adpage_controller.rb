class AdpageController < ApplicationController
  before_action :require_login
  #########db관리메인페이지##################
  def dbmain
    instance=[]
    @list=Menulist.all
    unless params[:id].to_i==1
      @list.each do|l|
        if l.kname==l.ename
          instance.push(l)
        end
      end
     @list=instance
    end
     
    
  end
  
  def rewrite
    id=params[:id]
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
  
    if Menulist.find_by(:kname => params[:kname])!=nil
      @ex_menu=Menulist.find_by(:kname => params[:kname])
      
    else  
      if (params[:kname]=="")||(params[:ename]=="")||(params[:ername]=="")
        redirect_to :back
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
    if (params[:kname]=="")||(params[:ename]=="")||(params[:ername]=="")
        redirect_to :back
    else
    remenu=Menulist.find(params[:id])
    remenu.kname=params[:kname]
    remenu.ename=params[:ename]
    remenu.ername=params[:ername]
    remenu.save
    redirect_to :back
    end
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
