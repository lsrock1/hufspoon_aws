class Data::RmenusController < ApplicationController
  before_action :require_login
  layout 'data'
  
  def create
    if params[:menulist]==nil
      @menulist=Menulist.find_by(kname: params[:rmenu][:menuname])
      @rmenu=Rmenu.new(rmenu_params)
      unless @menulist==nil
        @rmenu.emenuname=@menulist.ename
        @rmenu.cmenuname=@menulist.cname
        @rmenu.save
        if params[:rmenu][:pagenum].to_i==0
          rest_remenu @rmenu
        end
        redirect_to '/data/rests/'+@rmenu.rest_id.to_s
      end
    else
      @menulist=Menulist.new(menulist_params)
      @menulist.save
      @rmenu=Rmenu.new(rmenu_params)
      @rmenu.emenuname=@menulist.ename
      @rmenu.cmenuname=@menulist.cname
      @rmenu.save
      if params[:rmenu][:pagenum].to_i==0
        rest_remenu @rmenu
      end
      redirect_to '/data/rests/'+@rmenu.rest_id.to_s
    end
    
  end
  
  def update
    @menulist=Menulist.find_by(kname: params[:rmenu][:menuname])
    unless @menulist==nil
      @rmenu=Rmenu.find(params[:id])
      @rmenu.update(rmenu_params)
      @rmenu.emenuname=@menulist.ename
      @rmenu.cmenuname=@menulist.cname
      @rmenu.save
      if params[:rmenu][:pagenum].to_i==0
        rest_remenu @rmenu
      end
    end
    redirect_to :back
  end
  
  def destroy
    @rmenu=Rmenu.find(params[:id])
    @rmenu.destroy
    redirect_to "/data/rests/"+@rmenu.rest_id.to_s
  end
  
  private
    def rmenu_params
      params.require(:rmenu).permit(:rest_id,:menuname,:content, :pagenum, :cost, :picture)
    end
    
    def menulist_params
      params.require(:menulist).permit(:kname,:ename,:ername,:jnamea,:cname,:cnameb,:aname,:spanish,:germany,:portugal,:italia,:french,:u_picture)
    end
    
    def rest_remenu rmenu
      rest=Rest.find(rmenu.rest_id)
      rest.re_menu=rmenu.menuname
      rest.ere_menu=rmenu.emenuname
      rest.chinese=rmenu.cmenuname
      rest.save
    end
end
