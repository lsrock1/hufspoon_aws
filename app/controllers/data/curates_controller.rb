class Data::CuratesController < ApplicationController
  include Getlist
  before_action :require_login
  layout 'data'
  
  def index
    @id=params[:id]? params[:id].to_i : 1
    @curate=Curate.all
    @num=(@curate.length/10)+1
    @languageHash=languageHash()
    if @id==0
      @curate=@curate.select{|item| item.show!=0}
    else
      @curate=@curate.order('created_at DESC')[(@id-1)*10..10*(@id)-1]
    end
  end
  
  def new
    @language = languageHash.map{|key, value| [value[2], key]}
    @curate=Curate.new 
  end
  
  def create
     @curate=Curate.new(curate_params)
     @curate.save
     redirect_to '/data/curates'
  end
  
  def destroy
    @curate=Curate.find(params[:id])
    @curate.destroy
    redirect_to :back
  end
  
  def update
    if params[:curate][:show].to_i<8&&params[:curate][:show].to_i>=0
      @curate=Curate.find(params[:id])
      @curate.update(curate_params)
    end
    redirect_to :back
  end
  
  def edit
    @language = languageHash.map{|key, value| [value[2], key]}
    @curate = Curate.find(params[:id])
  end
  
  private
    def curate_params
       params.require(:curate).permit(:address,:keyword,:show,:startDate, :endDate, :dayOfWeek, :time, :language) 
    end
end
