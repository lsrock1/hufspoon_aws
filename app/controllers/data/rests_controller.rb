require 'csv'
class Data::RestsController < ApplicationController
  before_action :require_login
  layout 'data'
  
  def index
    @page=params[:page] ? params[:page].to_i : 1
    @rests=Rest.all
    @num=(@rests.length/50)+1
    @rest=@rests.all.sort{|a,b| a.name <=> b.name}[(@page-1)*50..50*(@page)-1]
  end
  
  def new
    @rest=Rest.new
  end
  
  def create
    if params[:map]
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
      end
      redirect_to :back
    elsif params[:upfile]
      file=params[:upfile]
      name=file.original_filename
      perms=['.csv']
      if perms.include?(File.extname(name).downcase)
        csv_text = file.tempfile.path
        @map=nil
        @rest=nil
        CSV.foreach(csv_text) do |row|
          if row[0]=='rest'
            @map=map row[10],row[11]
            begin
              @rest=@map.rests.find_by(name: row[1])
            rescue
              @rest=nil
            end
            
            if @rest
              @rest.update(map_id: @map.id,food: row[2],page: row[3],picture: row[4],re_menu: row[5],ere_menu: row[6],address: row[7],phone: row[8],open: row[9])
            else
              @rest=Rest.new(map_id: @map.id, name: row[1],food: row[2],page: row[3],picture: row[4],re_menu: row[5],ere_menu: row[6],address: row[7],phone: row[8],open: row[9])
              @rest.save
            end
          elsif row[0]=='menu'
            Menulist.gettrans(row[1],0)
            Rmenu.new(rest_id: @rest.id,menuname: row[1],emenuname: row[2],content: row[3],cost: row[4],category: row[5],pagenum: row[6]).save
          end
        end
      end
      redirect_to :back
    else
      redirect_to :back
    end
  end
  
  def edit
    @rest=Rest.find(params[:id])
  end

  def update
    @rest=Rest.find(params[:id])
    if params[:rest][:name]||params[:rest][:page]
      @rest.update(rest_params)
    elsif params[:rest][:picture]
      @rest.picture=@rest.picture+params[:rest][:picture]
      @rest.save
    end
    redirect_to :back
  end
  
  def destroy
    if params[:number]
      @rest=Rest.find(params[:id])
      arr=@rest.picture.split('http')[1..-1]
      arr.delete_at(params[:number].to_i)
      @rest.picture='http'+arr.join('http')
      @rest.picture= (@rest.picture=='http' ? '' : @rest.picture)
      @rest.save
    else
      @rest=Rest.find(params[:id])
      @map=Map.find(@rest.map_id)
      if @map.rests.length>=2
        @rest.destroy
      else
        @map.destroy
      end
    end
    redirect_to :back
  end
  
  def show
    @rest=Rest.find(params[:id])
    @rmenu=Rmenu.new
  end
  
  private
    def rest_params
      params.require(:rest).permit(:name,:food,:picture,:address,:phone,:open, :page)
    end
    
    def map_params
      params.require(:map).permit(:lat,:lon)
    end
    
    def map lat,lon
      map=Map.find_by(lat: lat,lon: lon)
      if map
        return map
      else
        map=Map.new(lat: lat,lon: lon)
        map.save
        return map
      end
    end
end
