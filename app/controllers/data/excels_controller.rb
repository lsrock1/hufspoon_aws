class Data::ExcelsController < ApplicationController
  before_action :require_login
  
  
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
