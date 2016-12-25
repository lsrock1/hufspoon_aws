class Data::RestsController < ApplicationController
  before_action :require_login
  layout 'data'
  
  def index
    @page=params[:page] ? params[:page].to_i : 1
    @rests=Rest.all
    @num=(@rests.length/50)+1
    @rest=@rests.all.order('name ASC')[(@page-1)*50..50*(@page)-1]
  end
  
  def new
    @rest=Rest.new
  end
  
  def create
    if params[:map][:lat]
      @map=Map.find_by(lat: params[:map][:lat].to_f,lon: params[:map][:lon].to_f)
      
      if @map
        unless Rest.find_by(map_id: @map.id,name: params[:rest][:name])
          @rest=Rest.new(rest_params)
          @rest.map_id=@map.id
          @rest.save
        end
      else
        @map=Map.new(map_params)
        @map.save
        @rest=Rest.new(rest_params)
        @rest.map_id=@map.id
        @rest.save
        redirect_to :back
      end
    elsif params[:upfile]
      file=params[:upfile]
      name=file.original_filename
      perms=['.csv']
      if perms.include?(File.extname(name).downcase)
        csv_text = file.tempfile.path
        CSV.foreach(csv_text,:encoding => 'euc-kr') do |row|
          row=row.to_s.splite(',')
          row=row.map{|s| s.delete '"'}.map{|s| s.delete " "}.map{|s| s.sub "nil",""}
          if row[0]=='rest'
            if newmap.rests.where(name: s[1].to_s).length==0
              newrest=Rest.new(map_id: newmap.id,name: s[1].to_s,food: s[2].to_s,page: s[3].to_s,picture: s[4].to_s,re_menu: s[5].to_s,ere_menu: s[6].to_s,address: s[7].to_s,phone: s[8].to_s,open: s[9].to_s)
              newrest.save
            else
              newrest=Rest.find_by(name: s[1].to_s)
            end
          elsif row[0]=='menu'
            
          end
        end
        redirect_to :back
      end
    else
      redirect_to :back
    end
  end
  
  def edit
    @rest=Rest.find(params[:id])
  end
  
  def update
    @rest=Rest.find(params[:id])
    @rest.update(rest_params)
    @rest.save
    if params[:rest][:page]
      redirect_to :back
    else
      redirect_to '/data/rests'
    end
  end
  
  def destroy
    @rest=Rest.find(params[:id])
    @map=Map.find(@rest.map_id)
    if @map.rests.length>=2
      @rest.destroy
    else
      @map.destroy
    end
    redirect_to :back
  end
  
  def show
    @rest=Rest.find(params[:id])
    @rmenu=Rmenu.new
  end
  
  private
    def rest_params
      params.require(:rest).permit(:name,:food,:picture,:address,:phone,:open)
    end
    
    def map_params
      params.require(:map).permit(:lat,:lon)
    end
end
