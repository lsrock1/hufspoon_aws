class BoardController < ApplicationController
  #before_action :require_session, except: [:hufslogin,:boardhome]
  
  def hufslogin
    if admin_signed_in?
       session[:name]="admin"
       session[:num]="0"
       session[:level]="hufspoon"
       redirect_to "/board/seepost/1"
    
    elsif params[:userId]==ENV["caf_id"]&&params[:userPw]==ENV["caf_pwd"]
        session[:name]="admin"
        session[:num]="0"
        session[:level]="인문관영양사"
        redirect_to "/board/seepost/1"
    end
  end
  
  
  def save
      
      Post.new( :name => params[:name],:level => params[:level],:num => params[:num],:content => params[:content],:title => params[:title]).save
      
      redirect_to '/board/seepost/1'
  end
  
  def out
     session.clear
     redirect_to '/board/seepost/1'
  end
  
  def remove
      if admin_signed_in?||session[:num]=="0"&&session[:name]=="admin"&&session[:level]=="인문관영양사"
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
      if admin_signed_in?||session[:num]=="0"&&session[:name]=="admin"&&session[:level]=="인문관영양사"
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
      Comment.new( :post_id => id, :content => params[:content],:name => params[:name],:level => params[:level],:num => params[:num]).save
      redirect_to :back
  end
  
  def seepost
    @id=params[:id].to_i
    @allpost=Post.all
    @num=(@allpost.length/20)+1
    @allpost=Post.all.order('created_at DESC')[20*(@id-1)..20*@id-1]
  end
  
  def writepage
    
  end
  
  def post
      id=params[:id]
      @p=Post.find(id)
      @allcom=Comment.where(:post_id => @p.id)
  end
end
