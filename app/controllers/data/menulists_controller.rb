require 'csv'
class Data::MenulistsController < ApplicationController
  before_action :require_login
  layout 'data'
  
  def index
    @search=true
    @page=params[:page] ? params[:page].to_i : 1
    @menulist=Menulist.all
    @num=(@menulist.length/300)+1
    if @page==0
      @list=@menulist.select{|item| item.kname==item.ename}
    else
      @list=@menulist.all.sort{|a,b| a.kname <=> b.kname}[(@page-1)*300..300*(@page)-1]
    end
  end
  
  def create
    if params[:menulist]
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
    elsif params[:upfile]
      file=params[:upfile]
      name=file.original_filename
      perms=['.csv']
      if perms.include?(File.extname(name).downcase)
        csv_text = file.tempfile.path
        num=0
        CSV.foreach(csv_text) do |row|
          unless num==0
            csv_hash(row)
          else
              num+=1
          end
        end
        
      end
      redirect_to :back
    else
      redirect_to :back
    end
  end
  
  def destroy
    delmenu=Menulist.find(params[:id])
    if Rmenu.find_by(:menuname => delmenu.kname)==nil
      delmenu.destroy
      redirect_to :back
    else
      redirect_to :back,notice: '해당 번역을 사용하는 일반식당 메뉴가 있습니다!'
    end
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
        redirect_to search_data_menulists_path(page: 0,keyword: @page)
      end
    end
  end
  
  def new
    @page=params[:page]
    @menulist=Menulist.new
  end
  
  def search
    @search=true
    @page=params[:page]
    @keyword=params[:keyword]
    @menulist=Menulist.where('kname Like ?', '%'+@keyword+'%').all
  end
  
  private
    def menulist_params
      params.require(:menulist).permit(:kname,:ename,:ername,:jnamea,:cname,:cnameb,:aname,:spanish,:germany,:portugal,:italia,:french,:u_picture)
    end
    
    def csv_hash string
      puts string
      menulist=Menulist.find_by(kname: string[1])
      if menulist
          if string[3]!=""&&string[3]!=nil
            menulist.ename=string[3]
          end
          if string[2]!=""&&string[2]!=nil
            menulist.ername=string[2]
          end
          if string[4]!=""&&string[4]!=nil
            menulist.jnamea=string[4]
          end
          if string[5]!=""&&string[5]!=nil
            menulist.cname=string[5]
          end
          if string[6]!=""&&string[6]!=nil
            menulist.cnameb=string[6]
          end
          if string[7]!=""&&string[7]!=nil
            menulist.aname=string[7]
          end
          if string[8]!=""&&string[8]!=nil
            menulist.spanish=string[8]
          end
          if string[9]!=""&&string[9]!=nil
            menulist.germany=string[9]
          end
          if string[10]!=""&&string[10]!=nil
            menulist.italia=string[10]
          end
          if string[11]!=""&&string[11]!=nil
            menulist.portugal=string[11]
          end
          if string[12]!=""&&string[12]!=nil
            menulist.french=string[12]
          end
          if string[13]!=""&&string[13]!=nil
            menulist.u_picture=string[13]
          end
          if string[14]!=""&&string[14]!=nil
            menulist.u_like=string[14]
          end
          menulist.save
        else
        Menulist.new(kname: string[1],ername: string[2],ename: string[3],jnamea: string[4],cname: string[5],cnameb: string[6], aname: string[7], spanish: string[8], germany: string[9], italia: string[10],portugal: string[11],french: string[12], u_picture: string[13], u_like: string[14]).save
      end
    end
end
