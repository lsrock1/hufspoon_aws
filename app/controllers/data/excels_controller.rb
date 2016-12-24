class Data::ExcelsController < ApplicationController
  before_action :require_login
  
  def excel
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
