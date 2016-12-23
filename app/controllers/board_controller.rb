class BoardController < ApplicationController
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
  
end
