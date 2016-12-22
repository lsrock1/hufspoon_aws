class Data::MenulistsController < ApplicationController
  before_action :require_login
  layout 'data'
  
  def index
    @search=true
    @page=params[:page] ? params[:page].to_i : 1
    @list=Menulist.all
    @num=(@list.length/300)+1
    if @page==0
      @list=@list.select{|item| item.kname==item.ename}
    else
      @list=@list.all.order('kname ASC')[(@page-1)*300...300*(@page)-1]
    end
  end
  
  def create
    @page=params[:page] ? params[:page] :params[:menulist][:page]
    #메뉴가 존재하면 그 메뉴를 찾아서 보여준다
    if Menulist.find_by(:kname => params[:menulist][:kname])!=nil
      @menulist=Menulist.find_by(:kname => params[:menulist][:kname])
    #메뉴가 존재하지 않으면 저장하되 안전성검사를 거친다   
    else  
      #이름과 영어 뜻 중 하나라도 비어있으면 저장하지 않는다
      unless (params[:menulist][:kname]=="")||(params[:menulist][:ename]=="")
        @menulist=Menulist.new(menulist_params)
        @menulist.save
      end
      redirect_to :back
    end
  end
  
  def destroy
    delmenu=Menulist.find(params[:id])
    if Rmenu.find_by(:menuname => delmenu.kname)==nil
      delmenu.destroy
    end
    redirect_to :back
  end
  
  def edit
    @menulist=Menulist.find(params[:id])
    @page=params[:page] ? params[:page] : params[:menulist][:page]
    @intinfo=isint(@page)
  end
  
  def update
    @page=params[:menulist][:page]
    @intinfo=isint(@page)
    if (params[:menulist][:kname]=="")||(params[:menulist][:ename]=="")
      redirect_to :back
    else
      @menulist=Menulist.find(params[:id])
      @menulist.update(menulist_params)
      @menulist.save
      if @intinfo!=nil
        if @intinfo>=0
          redirect_to "/data/menulists/?page="+@page
        else
          redirect_to "/data/rests/"+((@intinfo*-1).to_s)
        end
      else
        redirect_to "/adpage/search/0?keyword="+URI.encode(@info)
      end
    end
  end
  
  def new
    @page=params[:page]
    @menulist=Menulist.new
  end
  
  private
    def menulist_params
      params.require(:menulist).permit(:kname,:ename,:ername,:jnamea,:cname,:cnameb,:aname,:spanish,:germany,:portugal,:italia,:french,:u_picture)
    end
end
