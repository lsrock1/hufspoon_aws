class Data::RestsController < ApplicationController
  before_action :require_login
  
  def index
    @page=params[:page] ? params[:page].to_i : 1
    @rest=Rest.all
    @num=(@rest.length/50)+1
    @rest=@rest.all.order('name ASC')[(@page-1)*50...50*(@page)-1]
  end
  
  def new
    @rest=Rest.new
  end
  
  def create
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
      params.require(:rest).permit(:name,:food,:page,:picture,:address,:phone,:open)
    end
    
    def map_params
      params.require(:map).permit(:lat,:lon)
    end
end
