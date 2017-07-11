class Board::CommentsController < ApplicationController
  
  def destroy
    if admin_signed_in?
      id=params[:id]
      delcomment=Comment.find(id)
      delcomment.destroy
    end
    redirect_to :back 
  end
  
  def create
    unless params[:content].include? "</a>"
      
      @comment=Comment.new(comment_params)
      @comment.ip=request.remote_ip
      if admin_signed_in?
        @comment.name='admin'
        @comment.num=0
        if current_admin.email=='admin@hufs.ac.kr'
          @comment.level="hufspoon"
        else
          @comment.level="인문관영양사"
        end
      end
      @comment.save
        
      cookies[:comment]==nil ? cookies.permanent[:comment]=@comment.id : cookies.permanent[:comment]=cookies[:comment]+","+@comment.id.to_s
    end
    redirect_to :back
  end
  
  private
    def comment_params
      params.require(:comment).permit(:content,:post_id)
    end
end
