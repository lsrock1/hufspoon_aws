class Data::CuratesController < ApplicationController
  before_action :require_login
  layout 'data'
  
  def index
    @id=params[:id]? params[:id].to_i : 1
    @curate=Curate.all
    @num=(@curate.length/10)+1
    if @id==0
      @curate=@curate.select{|item| item.show!=0}
    else
      @curate=@curate.order('created_at DESC')[(@id-1)*10..10*(@id)-1]
    end
  end
  
  def new
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
    
    if params[:curate][:show].to_i<6&&params[:curate][:show].to_i>=0
        @curate=Curate.find(params[:id])
        if params[:curate][:show].to_i==0||Curate.find_by(show: params[:curate][:show])==nil
          @curate.show=params[:curate][:show]
          @curate.save
        end
    end
    redirect_to :back
  end
  
  private
    def curate_params
       params.require(:curate).permit(:address,:keyword,:show) 
    end
end
