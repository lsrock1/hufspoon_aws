class SystemsController < ApplicationController
  before_action :require_login
  
  def block
    if params[:identity] == 'post'
      del = Post.find(params[:id])
      Banned.new(identity: params[:identity], number: params[:id], ip: del.ip).save
      
    elsif params[:identity] == 'comment'
      del = Comment.find(params[:id])
      Banned.new(identity: params[:identity], number: params[:id], ip: del.ip).save
    
    elsif params[:identity] == 'ip'
      if params[:id][0..3] == 'post'
        del = Post.find(params[:id][4..-1])
      else
        del = Comment.find(params[:id][7..-1])
      end
      
      Banned.new(identity: params[:identity], ip: del.ip).save
    end
    
    redirect_to :back
  end
  
  def domain
    Menulist.all.each do |menu|
      if menu.u_picture and menu.u_picture.include? '.org'
        menu.update(u_picture: menu.u_picture.sub('org', 'cc'))
      end
    end
    
    Rmenu.all.each do |menu|
      if menu.picture and menu.picture.include? 'org'
        menu.update(picture: menu.picture.sub('org', 'cc'))
      end
    end
    
    Rest.all.each do |rest|
      if rest.picture and rest.picture.include? 'org'
        rest.update(picture: rest.picture.sub('org', 'cc'))
      end
    end
    
    redirect_to '/'
  end
  
  def refresh
    day = params[:day]
    
    [Breakfast,Lunch1,Lunch2,Lunchnoodle,Dinner,Flunch,Fdinner,Menua,Menub]
    .map{|meal| meal.find_by(date: day)}
    .select{|meal| meal != nil}
    .map{|meal| meal.destroy}
    
    redirect_to '/'
  end
  
  def out
    session.clear
    redirect_to '/'
  end
end
