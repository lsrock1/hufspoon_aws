class Board::CommentsController < ApplicationController
  
  def destroy
    if admin_signed_in?||session[:num]=="0"&&session[:name]=="admin"&&session[:level]=="인문관영양사"
      id=params[:id]
      delcomment=Comment.find(id)
      delcomment.destroy
        
      redirect_to :back
    else
      redirect_to :back 
    end 
  end
  
  def create
    @comment=Comment.new(comment_params)
    @comment.ip=request.remote_ip
    @comment.save
      
    cookies[:comment]==nil ? cookies.permanent[:comment]=@comment.id : cookies.permanent[:comment]=cookies[:comment]+","+@comment.id.to_s
    redirect_to :back
  end
  
  private
    def comment_params
      if admin_signed_in?||session[:num]=="0"&&session[:name]=="admin"&&session[:level]=="인문관영양사"
        params.require(:comment).permit(:num,:name,:level,:content,:post_id)
      else
        params.require(:comment).permit(:content,:post_id)
      end
    end
end
