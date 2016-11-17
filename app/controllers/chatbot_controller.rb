class ChatbotController < ApplicationController
    
    def keyboard
        render :json =>
        {
            type: "buttons",
            buttons: ["Select Language", "Today Menu!"]
        }
    end
    
    def message
        user=params[:user_key]
        content=params[:content]
        begin
          user=User.find_by(key: user)
        rescue
          user=User.new(key: user,count: 0,step: 0)
        end
        user.count+=1
        user.save
        if content=="Select Language"
            
            render :json =>
            {
                message:{
                  text: "What is your language?"  
                },
                
                keyboard: {
                    type: "buttons",
                    buttons: ["English","한글","中文","Español","Deutsch","Italiano","português"]
                }
            }
        elsif content=="English"||content=="한글"||content=="中文"||content=="Español"||content=="Deutsch"||content=="Italiano"||content=="Português"
            if content=="English"
                user.language=0
            elsif content=="한글"
                user.language=4
            elsif content=="中文"
                user.language=2
            elsif content=="Español"
                user.language=6
            elsif content="Deutsch"
                user.language=7
            elsif content="Italiano"
                user.language=8
            elsif content="Português"
                user.language=9
            end
            user.step=1
            user.save
            
            render :json =>
            {
                message:{
                  text: "Where is your country?"  
                }
            }
        elsif user.step==1
            user.country=content
            user.step=0
            user.save
            
            render :json =>
            {
                message:{
                    text: "From "+content+", I want to go there!"+"\n"+
                    "You can change the language anytime!"
                },
                keyboard:{
                    type: "buttons",
                    buttons: ["Select Language", "Today Menu!"]
                }
            }
        elsif content=="Today Menu!"
            if user.language!=nil
            render :json =>
            {
                message:{
                    text: "Which cafeteria do you want to go?"
                },
                keyboard:{
                    type: "buttons",
                    buttons: ["Humanities","Faculty","Sky Lounge"]
                }
            }
            else
                render :json =>
                {
                    message:{
                        text: "Select your language first!"
                    },
                    keyboard:{
                        type: "buttons",
                        buttons: ["Select Language", "Today Menu!"]
                    }
                }
            end
        elsif content=="Humanities"||content=="Faculty"||content=="Sky Lounge"
            
            #------------------------파싱 그대로 가져옴--------------------------------
            @id=user.language.to_i
            time=Time.new.in_time_zone("Seoul")
            dd=time.day
            mm=time.month
            if dd<10 
              dd='0'+dd.to_s
            end
              
            if mm<10 
                mm='0'+mm.to_s
            end 
            @day=time.year.to_s+mm.to_s+dd.to_s
            @w=time.wday
            
            check=Lunch1.find_by(:date => @day)
            begin
              if check==nil
                parsing_func(@day)
              end
            rescue
            end
            
            if @w==0
              render :json =>
              {
                  message: {
                      text: "Sunday Cafeteria went to bed!"
                  },
                  keyboard:{
                      type: "buttons",
                      buttons: ["Select Language", "Today Menu!"]
                  }
              }
            else#일요일이면 레스토랑 추천!
            
            menulist=[]
            #----------------파싱 그대로 가져옴----------------------
                if content=="Humanities"
                  menulist=[Breakfast,Lunch1,Lunch2,Lunchnoodle,Dinner].map{|data| make_list(data,@day,@id)}
                    
                elsif content=="Faculty"
                  menulist=[Flunch,Fdinner,Menua,Menub].map{|data| make_list(data,@day,@id)}
                    
                else
                  menulist=[Menua,Menub].map{|data| make_list(data,@day,@id)}
                    
                end
                info=""
                    #--문자열 가공
                    menulist.each do |meal|
                      if meal['price']!=nil||meal['kcal']!=nil
                        info="<<"+meal['name'].titleize+">>"+
                          "\n"+meal['time']+"/"+meal['price']+
                          "\n"+"\n"+meal['menu'].shift.titleize
                          if meal['menu']!=[]
                             info=info+"\n"+meal['menu'].join(",")
                          end
                          if meal['ingre']!=[]
                              info=info+"\n"+"\n"+meal['ingre'].join(",")
                          else
                            info=info+"\n"
                          end
                          if meal['kcal']!=nil
                           info=info+"\n"+meal['kcal']
                          end
                      end
                    end
                    
                   render :json =>
                   {
                       message:{
                           text: info,
                           message_button: {
                              label: "What's next?",
                              url: "http://www.hfspn.co"
                            }
                           
                       },
                       keyboard:{
                           type: "buttons",
                           buttons: ["Select Language","Today Menu!"]
                       }
                   }
            end
        else
            render :json =>
            {
                message:{
                    text: "Wrong access"
                },
                keyboard:{
                    type: "buttons",
                    buttons: ["select Language","Today Menu!"]
                }
            }
        end
    end
    
    def delfriend
        begin
            user=params[:user_key]
            user=User.find_by(key: user)
            user.destroy
        rescue
        end
        render :json => {}
    end
    
    def regfriend
        user=params[:user_key]
        User.new(key: user,step: 0,count: 0).save
        render :json =>
        {}
    end
    
    def chat_room
        user=params[:user_key]
        user=User.find_by(key: user)
        user.chat_room=0
        user.save
        render :json =>{}
    end
end
