class Board::PostsController < ApplicationController
  before_action :banned_user
  
  def index
    @page=(params[:page] ? params[:page].to_i : 1)
    @allpost=Post.all
    @num=(@allpost.length/20)+1
    @allpost=Post.all.order('created_at DESC')[20*(@page-1)..20*@page-1]
  end
  
  def show
    id=params[:id]
    @p=Post.find(id)
    @allcom=Comment.where(:post_id => @p.id)
    @comment=Comment.new
  end
  
  def new
    @post=Post.new
  end
  
  def create
    @post=Post.new(post_params)
    @post.ip=request.remote_ip
    @post.save
    cookies[:post]==nil ? cookies.permanent[:post]=@post.id : cookies.permanent[:post]=cookies[:post]+","+@post.id.to_s
    redirect_to '/posts'
  end
  
  
  def destroy
    if admin_signed_in?||session[:num]=="0"&&session[:name]=="admin"&&session[:level]=="인문관영양사"
      id=params[:id]
      delpost=Post.find(id)
      delpost.destroy
      redirect_to '/posts'
    else
      redirect_to :back
    end
  end
  
  private
    def post_params
      if admin_signed_in?||session[:num]=="0"&&session[:name]=="admin"&&session[:level]=="인문관영양사"
        params.require(:post).permit(:num,:name,:level,:content,:title)
      else
        params.require(:post).permit(:content,:title)
      end
    end
end
