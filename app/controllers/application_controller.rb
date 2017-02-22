require 'SecureRandom'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }
  
  def require_login
    unless admin_signed_in?
      redirect_to "/admins/sign_in"
    end
  end
  
  def banned_user
    if cookies[:post]
      cookies[:post].split(",").each do |id|
        if Banned.find_by(identity: "post",number: id)!=nil
          redirect_to 'https://meta.wikimedia.org/wiki/Banned_user'
        end
      end
    elsif cookies[:comment]
      cookies[:comment].split(",").each do |id|
        if Banned.find_by(identity: "comment",number: id)!=nil
          redirect_to 'https://meta.wikimedia.org/wiki/Banned_user'
        end
      end
    end
    
    if Banned.find_by(identity: "ip",ip: request.remote_ip)!=nil
      redirect_to 'https://meta.wikimedia.org/wiki/Banned_user'
    end
    rescue ActionController::RedirectBackError
      redirect_to root_path
  end
  
  def isint(str)
    i=Integer(str) 
    return i 
    rescue 
    return nil
  end
  
  def randomToken
    if cookies[:idToken].blank?
      cookies.permanent[:idToken]=SecureRandom.uuid
    end
    @idToken=cookies[:idToken]
  end
end