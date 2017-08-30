require "csv"
class Data::MenulistsController < ApplicationController
  before_action :require_login
  layout "data"
  
  def index
    @search = true
    @page = params[:page] ? params[:page].to_i : 1
    @menulist = Menulist.all
    @num = (@menulist.length/300)+1
    if @page == 0
      @list = @menulist.select{|item| item.kname==item.ename}
    else
      @list = @menulist.all.sort_by{|a| a.kname}[(@page-1) * 300..300 * (@page)-1]
    end
  end
  
  def create
    if params[:menulist]
      @page=params[:page] ? params[:page] :params[:menulist][:page]
      if Menulist.find_by(kname: params[:menulist][:kname])!=nil
        @menulist=Menulist.find_by(kname: params[:menulist][:kname])
      else
        unless (params[:menulist][:kname] == "") || (params[:menulist][:ename] == "")
          @menulist = Menulist.new(menulist_params)
          @menulist.save
        end
        redirect_to :back
      end
    elsif params[:upfile]
      file = params[:upfile]
      name = file.original_filename
      perms = ['.csv']
      if perms.include?(File.extname(name).downcase)
        csv_text = file.tempfile.path
        num = 0
        keys = Menulist.column_names
        CSV.foreach(csv_text) do |row|
          if num == 0
            num = num + 1
          else
            csv_hash(row, keys)
          end
        end
        
      end
      redirect_to :back
    else
      redirect_to :back
    end
  end
  
  def destroy
    delmenu = Menulist.find(params[:id])
    if Rmenu.find_by(menuname: delmenu.kname) == nil
      delmenu.destroy
      redirect_to :back
    else
      redirect_to :back, notice: "해당 번역을 사용하는 일반식당 메뉴가 있습니다!"
    end
  end
  
  def edit
    @menulist = Menulist.find(params[:id])
    @page = params[:page] ? params[:page] : params[:menulist][:page]
    @intinfo = isint(@page)
  end
  
  def update
    @page=params[:menulist][:page]
    @intinfo=isint(@page)
    if (params[:menulist][:kname] == "")||(params[:menulist][:ename] == "")
      redirect_to :back
    else
      @menulist = Menulist.find(params[:id])
      @menulist.update(menulist_params)
      @menulist.touch
      if @intinfo!=nil
        if @intinfo>=0
          redirect_to "/data/menulists/?page=" + @page
        else
          redirect_to "/data/rests/" + ((@intinfo*-1).to_s)
        end
      else
        redirect_to search_data_menulists_path(page: 0, keyword: @page)
      end
    end
  end
  
  def new
    @page=params[:page]
    @menulist=Menulist.new
  end
  
  def search
    @search = true
    @page = params[:page]
    @keyword = params[:keyword]
    @menulist = Menulist.where('kname Like ?', '%' + @keyword + '%').all
  end
  
  def top
    @menu=Hash.new(0)
    [Breakfast,Lunch1,Lunch2,Lunchnoodle,Dinner].map{|cafe| cafe.make_hash(@menu)}
    @menu=@menu.sort_by {|_,number| number}.reverse[0...500].concat([['닭강정',1],['순대',1],['떡라면',1],['치즈라면',1],['김밥',1],['토스트',1],['떡볶이',1],['치즈',1],['공기밥',1],['라면',1]])
    items=@menu.map{|item| item[0]}
    @menu=@menu.to_h
    @list=Menulist.all.where(kname: items).sort_by{|a| @menu[a.kname]}.reverse
  end
  
  private
    def menulist_params
      params.require(:menulist).permit(:kname, :ename, :ername, :jnamea, :cname, :cnameb, :aname,:spanish,:germany,:portugal,:italia,:french,:esperanto,:u_picture)
    end
    
    def csv_hash string, keys
      menulist = Menulist.find_by(kname: string[1])
      name_hash = keys[1..-1].zip(string[1..-1]).to_h
      if menulist
        menulist.update(name_hash.delete_if{|k,v| v.blank?})
      elsif !name_hash['kname'].blank?
        Menulist.new(name_hash).save
      end
    end
end
