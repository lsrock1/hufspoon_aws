class BoardController < ApplicationController
  #before_action :require_session, except: [:hufslogin,:boardhome]
  before_action :banned_user
  
  def login
    if admin_signed_in?
       session[:name]="admin"
       session[:num]="0"
       session[:level]="hufspoon"
    elsif params[:userId]==ENV["caf_id"]&&params[:userPw]==ENV["caf_pwd"]
        session[:name]="admin"
        session[:num]="0"
        session[:level]="인문관영양사"
    end
    redirect_to "/posts"
  end
  
  def block
    if admin_signed_in?||session[:num]=="0"&&session[:name]=="admin"&&session[:level]=="인문관영양사"
      if params[:identity]=='post'
        del=Post.find(params[:id])
        Banned.new(:identity => params[:identity], :number => params[:id], :ip => del.ip).save
      elsif params[:identity]=='comment'
        del=Comment.find(params[:id])
        Banned.new(:identity => params[:identity], :number => params[:id], :ip => del.ip).save
      elsif params[:identity]=='ip'
        if params[:id][0..3]=='post'
          del=Post.find(params[:id][4..-1])
        else
          del=Comment.find(params[:id][7..-1])
        end
        Banned.new(:identity => params[:identity], :ip => del.ip).save
      end
        redirect_to :back
    else
        redirect_to :back 
    end
  end
  
  
end
