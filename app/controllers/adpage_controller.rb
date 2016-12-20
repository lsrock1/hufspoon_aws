class AdpageController < ApplicationController
  before_action :require_login
  
  #################메뉴 관리 클래스####################
  #메뉴검색 페이지
  def search
    @info=params[:id]
    @key=params[:keyword]
    @list=[]
    Menulist.all.each do|e|
      if e.kname.include? @key
        @list.push(e)
      end
    end
  end
  
 
  ###################엑셀 관련 클래스######################
  #db->엑셀
  def download
    workbook = WriteXLSX.new('public/public/translate.xlsx')
    worksheet = workbook.add_worksheet
    
    num=0
    Menulist.all.each do|a|
      worksheet.write(num,0,a.kname)
      worksheet.write(num,1,a.ername)
      worksheet.write(num,2,a.ename)
      worksheet.write(num,3,a.jnamea)
      worksheet.write(num,4,a.cname)#간체
      worksheet.write(num,5,a.cnameb)#번체
      worksheet.write(num,6,a.aname)
      worksheet.write(num,7,a.spanish)
      worksheet.write(num,8,a.germany)
      worksheet.write(num,9,a.italia)
      worksheet.write(num,10,a.portugal)
      worksheet.write(num,11,a.french)
      worksheet.write(num,12,a.u_picture)
      num=num+1
    end
      workbook.close
    send_file 'public/public/translate.xlsx', :type=>"application/xlsx", :x_sendfile=>true
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
      
      xlsx = Roo::Spreadsheet.open('public/public/down.xlsx')
      sheet1 = xlsx.sheet(0)
        sheet1.each do |s|
          unless (s[0].to_s=="")
            if Menulist.find_by(:kname => s[0].to_s.strip)!=nil
              exme=Menulist.find_by(:kname => s[0].to_s.strip)
              if s[2]!=""&&s[2]!=nil
               exme.ename=s[2]
              end
              if s[1]!=""&&s[1]!=nil
              exme.ername=s[1]
              end
              if s[3]!=""&&s[3]!=nil
              exme.jnamea=s[3]
              end
              if s[4]!=""&&s[4]!=nil
              exme.cname=s[4]
              end
              if s[5]!=""&&s[5]!=nil
              exme.cnameb=s[5]
              end
              if s[6]!=""&&s[6]!=nil
              exme.aname=s[6]
              end
              if s[7]!=""&&s[7]!=nil
              exme.spanish=s[7]
              end
              if s[8]!=""&&s[8]!=nil
              exme.germany=s[8]
              end
              if s[9]!=""&&s[9]!=nil
              exme.italia=s[9]
              end
              if s[10]!=""&&s[10]!=nil
              exme.portugal=s[10]
              end
              if s[11]!=""&&s[11]!=nil
              exme.french=s[11]
              end
              if s[12]!=""&&s[12]!=nil
              exme.u_picture=s[12]
              end
              exme.save
            else
              
              newme=Menulist.new
              newme.kname=s[0]
              newme.ename=s[2]
              newme.ername=s[1]
              newme.jnamea=s[3]
              newme.cname=s[4]
              newme.cnameb=s[5]
              newme.aname=s[6]
              newme.spanish=s[7]
              newme.germany=s[8]
              newme.italia=s[9]
              newme.portugal=s[10]
              newme.french=s[11]
              newme.u_picture=s[12]
              newme.save
              
            end
          end
        end
      redirect_to :back
      end
      
    end
  end
  
end
