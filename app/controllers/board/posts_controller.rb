class Board::PostsController < ApplicationController
  before_action :banned_user
  layout 'board'
  def index
    @search=true
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
    if admin_signed_in?
      @post.name='admin'
      @post.num=0
      if current_admin.email=='admin@hufs.ac.kr'
        @post.level="hufspoon"
      else
        @post.level="인문관영양사"
      end
    end
    @post.save
    cookies[:post]==nil ? cookies.permanent[:post]=@post.id : cookies.permanent[:post]=cookies[:post]+","+@post.id.to_s
    redirect_to '/posts'
  end
  
  
  def destroy
    if admin_signed_in?
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
      params.require(:post).permit(:content,:title)
    end
end
