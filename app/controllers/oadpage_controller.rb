class OadpageController < ApplicationController
  before_action :require_login
  
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
