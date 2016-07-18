class BoardController < ApplicationController
  before_action :require_session, except: [:hufslogin,:boardhome]
  
  def hufslogin
    if admin_signed_in?
       session[:name]="admin"
       session[:num]="0"
       session[:level]="hufspoon"
    end
    if session[:name]!=nil&&session[:num]!=nil&&session[:level]!=nil
       redirect_to '/board/boardhome' 
    end
  end
  
  def boardhome
    if session[:name]==nil
        id=params[:userId]
        pwd=params[:userPw]
        if id.strip==""||pwd.strip==""
            redirect_to '/board/hufslogin'
        elsif id==nil||pwd==nil
            redirect_to '/board/hufslogin'
        elsif id==ENV["caf_id"]&&ENV["caf_pwd"]
            session[:name]="admin"
            session[:num]="0"
            session[:level]="영양사님"
        else
            @agent = Mechanize.new
            @agent.get('http://builder.hufs.ac.kr/user/indexMain.action?command=&siteId=haksa') do | home_page |
            login_form = home_page.form_with(:name => "mem_form")
            login_form.userId = id
            login_form.userPw = pwd
            @agent.submit(login_form)
            
            #cookies = agent.cookie_jar.store.map {|i|  i} #need to store the cookie with a specific ppin browser
            $info=@agent.get('https://builder.hufs.ac.kr/user/indexFrame.action?framePath=div2_row_1.jsp&siteId=hufs&leftPage=&rightPage=08.html') #page behind password protection
            end
            iden=$info.search('strong.txt02').text
            if iden!='()'
              @level=$info.search('strong.txt01').text
              bfirst=iden.index('(')
              @name=iden[0..(bfirst-1)]
              @num=iden[(bfirst+1)..-2]
              if id!=@num
                 redirect_to '/board/hufslogin' 
              end
              session[:name]=@name
              session[:num]=@num
              session[:level]=@level
            else
              redirect_to'/board/hufslogin'
            end
        end
    end
  end
  
  def save
      @name=params[:name]
      @level=params[:level]
      @num=params[:num]
      content=params[:content]
      title=params[:title]
      if @name==nil||@level==nil||@num==nil
          redirect_to '/board/hufslogin'
      else
          np=Post.new(:num => @num,:level => @level, :name => @name, :content => content,:title => title)
          np.save
          redirect_to '/board/seepost/1'
      end
  end
  
  def out
     session.clear
     redirect_to '/board/hufslogin'
  end
  
  def remove
     if admin_signed_in?
        id=params[:id]
        delpost=Post.find(id)
        delcomment=Comment.where(:post_id => delpost.id)
        
        delcomment.each do|d|
            d.destroy
        end
        
        delpost.destroy
        redirect_to '/board/seepost/1'
     else
        redirect_to :back 
     end
  end
  
  def cremove
      if admin_signed_in?
        id=params[:id]
        
        delcomment=Comment.find(id)
        delcomment.destroy
        
        redirect_to :back
      else
        redirect_to :back 
      end
  end
  
  def comment
      id=params[:id]
      Comment.new(:num => params[:num],:name => params[:name], :level => params[:level], :post_id => id, :content => params[:content]).save
      redirect_to :back
  end
  
  def seepost
    @id=params[:id].to_i
    @allpost=Post.all
    @num=(@allpost.length/20)+1
    if @id==0
      @allpost=Post.where(:num => session[:num])
    else
      @allpost=Post.all.order('created_at DESC')[20*(@id-1)..20*@id-1]
    end
  end
  
  def writepage
    
  end
  
  def post
      id=params[:id]
      @p=Post.find(id)
      @allcom=Comment.where(:post_id => @p.id)
  end
end
