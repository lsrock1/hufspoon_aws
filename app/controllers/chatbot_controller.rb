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
                    "You can change language anytime!"
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
            
            @breakfast=[]
            @lunch1=[]
            @lunch2=[]
            @lunchnoodle=[]
            @dinner=[]
            
            @flunch=[]
            @fdinner=[]
            
            @menua=[]
            @menub=[]
            
            @breakfastingre=[]
            @lunch1ingre=[]
            @lunch2ingre=[]
            @lunchnoodleingre=[]
            @dinneringre=[]
            
            @flunchingre=[]
            @fdinneringre=[]
            
            @menuaingre=[]
            @menubingre=[]
            ##############인문관식당 파싱 자료 분류#############
            
            
            
            innum=0
            breakfast=Breakfast.find_by(:date => @day)
            unless breakfast==nil
              breakfast=breakfast.menu
              breakfast=breakfast.split("$")
              @breakfasttime=breakfast.shift
              breakfast.each do |l|
                if l.index(':')!=nil
                  @breakfastingre.concat(makeingre(l,@id))
                elsif l[-1]=="l"
                  @breakfastkcal=l
                elsif l[-1]=="원"
                  @breakfastprice=l[0..-2]+"won"
                else
                  xfood=l.strip
                  judvar=checkexist(xfood,@id)
                  if judvar==1
                    @breakfast.push(transout(xfood,@id))
                  elsif judvar==0
                    @breakfast.push(xfood)
                  else
                    @breakfast.push(xfood)
                    new_menu(xfood)
                  end
                  if innum==0
                    @breakfast_main=Menulist.find_by(:kname => xfood)
                  end
                end
                  
                innum=1+innum
              end
            end
            
          
            innum=0
            lunch1=Lunch1.find_by(:date => @day)
            
            
            unless lunch1==nil
              lunch1=lunch1.menu
              lunch1=lunch1.split("$")
              @lunch1time=lunch1.shift
              lunch1.each do |l|
                if l.index(':')!=nil
                  @lunch1ingre.concat(makeingre(l,@id))
                elsif l[-1]=="l"
                  @lunch1kcal=l
                elsif l[-1]=="원"
                  @lunch1price=l[0..-2]+"won"
                else
                  xfood=l.strip
                  judvar=checkexist(xfood,@id)
                  if judvar==1
                    @lunch1.push(transout(xfood,@id))
                  elsif judvar==0
                    @lunch1.push(xfood)
                  else
                    @lunch1.push(xfood)
                    new_menu(xfood)
                  end
                  if innum==0
                    @lunch1_main=Menulist.find_by(:kname => xfood)
                  end
                end
                  
                innum=1+innum
              end
            end
            
            
            innum=0
            lunch2=Lunch2.find_by(:date => @day)
            unless lunch2==nil
              lunch2=lunch2.menu
              lunch2=lunch2.split("$")
              @lunch2time=lunch2.shift
              lunch2.each do |l|
                if l.index(':')!=nil
                  @lunch2ingre.concat(makeingre(l,@id))
                elsif l[-1]=="l"
                  @lunch2kcal=l
                elsif l[-1]=="원"
                  @lunch2price=l[0..-2]+"won"
                else
                  xfood=l.strip
                  judvar=checkexist(xfood,@id)
                  if judvar==1
                    @lunch2.push(transout(xfood,@id))
                  elsif judvar==0
                    @lunch2.push(xfood)
                  else
                    @lunch2.push(xfood)
                    new_menu(xfood)
                  end
                  if innum==0
                    @lunch2_main=Menulist.find_by(:kname => xfood)
                  end
                end
                  
                innum=1+innum
              end
            end
            
            innum=0
            lunchnoodle=Lunchnoodle.find_by(:date => @day)
            unless lunchnoodle==nil
              lunchnoodle=lunchnoodle.menu
              lunchnoodle=lunchnoodle.split("$")
              @lunchnoodletime=lunchnoodle.shift
              lunchnoodle.each do |l|
                if l.index(':')!=nil
                  @lunchnoodleingre.concat(makeingre(l,@id))
                elsif l[-1]=="l"
                  @lunchnoodlekcal=l
                elsif l[-1]=="원"
                  @lunchnoodleprice=l[0..-2]+"won"
                else
                  xfood=l.strip
                  judvar=checkexist(xfood,@id)
                  if judvar==1
                    @lunchnoodle.push(transout(xfood,@id))
                  elsif judvar==0
                    @lunchnoodle.push(xfood)
                  else
                    @lunchnoodle.push(xfood)
                    new_menu(xfood)
                  end
                  if innum==0
                    @lunchnoodle_main=Menulist.find_by(:kname => xfood)
                  end
                end
                  
                innum=1+innum
              end
            end
            
            innum=0
            dinner=Dinner.find_by(:date => @day)
            unless dinner==nil
              dinner=dinner.menu
              dinner=dinner.split("$")
              @dinnertime=dinner.shift
              dinner.each do |l|
                if l.index(':')!=nil
                  @dinneringre.concat(makeingre(l,@id))
                elsif l[-1]=="l"
                  @dinnerkcal=l
                elsif l[-1]=="원"
                  @dinnerprice=l[0..-2]+"won"
                else
                  xfood=l.strip
                  judvar=checkexist(xfood,@id)
                  if judvar==1
                    @dinner.push(transout(xfood,@id))
                  elsif judvar==0
                    @dinner.push(xfood)
                  else
                    @dinner.push(xfood)
                    new_menu(xfood)
                  end
                  if innum==0
                    @dinner_main=Menulist.find_by(:kname => xfood)
                  end
                end
                  
                innum=1+innum
              end
            end
            
            
            innum=0
            flunch=Flunch.find_by(:date => @day)
            unless flunch==nil
              flunch=flunch.menu
              flunch=flunch.split("$")
              @flunchtime=flunch.shift
              flunch.each do |l|
                if l[-1]=="l"
                  @flunchkcal=l
                elsif l[-1]=="원"
                  @flunchprice=l[0..-2]+" won"
                else
                  if l.index("(")!=nil
                    xfirst=l.index("(")
                    xfood=l[0..(xfirst-1)].strip
                    @flunchingre.concat(makeingre(l[xfirst..-1],@id))
                  else
                    xfood=l.strip
                  end
                  
                  #메뉴가 이상한 문자로 엮여있을 경우
                  if xfood.index("&")!=nil||xfood.index("/")!=nil||xfood.index("-")!=nil
                    @flunch.push(spliter(xfood,@id))
                    if innum==0
                      @flunch_main=how_like(xfood,0)
                    end
                  else
                    
                    judvar=checkexist(xfood,@id)
                    if judvar==1
                      @flunch.push(transout(xfood,@id))
                    elsif judvar==0
                      @flunch.push(xfood)
                    else
                      @flunch.push(xfood)
                      new_menu(xfood)
                    end
                    if innum==0
                      @flunch_main=Menulist.find_by(:kname => xfood)
                    end
                  end
                end
                innum=1+innum
              end
            end
            
            innum=0
            fdinner=Fdinner.find_by(:date => @day)
            unless fdinner==nil
              fdinner=fdinner.menu
              fdinner=fdinner.split("$")
              @fdinnertime=fdinner.shift
              fdinner.each do |l|
                if l[-1]=="l"
                  @fdinnerkcal=l
                elsif l[-1]=="원"
                  @fdinnerprice=l[0..-2]+" won"
                else
                  if l.index("(")!=nil
                    xfirst=l.index("(")
                    xfood=l[0..(xfirst-1)].strip
                    @fdinneringre.concat(makeingre(l[xfirst..-1],@id))
                  else
                    xfood=l.strip
                  end
                  
                  #메뉴가 이상한 문자로 엮여있을 경우
                  if xfood.index("&")!=nil||xfood.index("/")!=nil||xfood.index("-")!=nil
                    @fdinner.push(spliter(xfood,@id))
                    if innum==0
                      @fdinner_main=how_like(xfood,0)
                    end
                  else
                    
                    judvar=checkexist(xfood,@id)
                    if judvar==1
                      @fdinner.push(transout(xfood,@id))
                    elsif judvar==0
                      @fdinner.push(xfood)
                    else
                      @fdinner.push(xfood)
                      new_menu(xfood)
                    end
                    if innum==0
                      @fdinner_main=Menulist.find_by(:kname => xfood)
                    end
                  end
                end
                innum=innum+1
              end
            end
            
            innum=0
            menua=Menua.find_by(:date => @day)
            unless menua==nil
              menua=menua.menu
              menua=menua.split("$")
              @menuatime=menua.shift
              menua.each do |l|
                if l[-1]=="l"
                  @menuakcal=l
                elsif l[-1]=="원"
                  @menuaprice=l[0..-2]+" won"
                else
                  if l.index("(")!=nil
                    xfirst=l.index("(")
                    xfood=l[0..(xfirst-1)].strip
                    @menuaingre.concat(makeingre(l[xfirst..-1],@id))
                  else
                    xfood=l.strip
                  end
                  
                  #메뉴가 이상한 문자로 엮여있을 경우
                  if xfood.index("&")!=nil||xfood.index("/")!=nil||xfood.index("-")!=nil
                    @menua.push(spliter(xfood,@id))
                    if innum==0
                      @menua_main=how_like(xfood,0)
                    end
                  else
                    
                    judvar=checkexist(xfood,@id)
                    if judvar==1
                      @menua.push(transout(xfood,@id))
                    elsif judvar==0
                      @menua.push(xfood)
                    else
                      @menua.push(xfood)
                      new_menu(xfood)
                    end
                    if innum==0
                      @menua_main=Menulist.find_by(:kname => xfood)
                    end
                  end
                end
                innum=1+innum
              end
            end
            
            innum=0
            menub=Menub.find_by(:date => @day)
            unless menub==nil
              menub=menub.menu
              menub=menub.split("$")
              @menubtime=menub.shift
              menub.each do |l|
                if l[-1]=="l"
                  @menubkcal=l
                elsif l[-1]=="원"
                  @menubprice=l[0..-2]+" won"
                else
                  if l.index("(")!=nil
                    xfirst=l.index("(")
                    xfood=l[0..(xfirst-1)].strip
                    @menubingre.concat(makeingre(l[xfirst..-1],@id))
                  else
                    xfood=l.strip
                  end
                  
                  #메뉴가 이상한 문자로 엮여있을 경우
                  if xfood.index("&")!=nil||xfood.index("/")!=nil||xfood.index("-")!=nil
                    @menub.push(spliter(xfood,@id))
                    if innum==0
                      @menub_main=how_like(xfood,0)
                    end
                  else
                    
                    judvar=checkexist(xfood,@id)
                    if judvar==1
                      @menub.push(transout(xfood,@id))
                    elsif judvar==0
                      @menub.push(xfood)
                    else
                      @menub.push(xfood)
                      new_menu(xfood)
                    end
                    if innum==0
                      @menub_main=Menulist.find_by(:kname => xfood)
                    end
                  end
                end
                innum=innum+1
              end
            end
            
            @breakfastingre=@breakfastingre.uniq
            @lunch1ingre=@lunch1ingre.uniq
            @lunch2ingre=@lunch2ingre.uniq
            @lunchnoodleingre=@lunchnoodleingre.uniq
            @dinneringre=@dinneringre.uniq
            
            @flunchingre=@flunchingre.uniq
            @fdinneringre=@fdinneringre.uniq
            
            @menuaingre=@menuaingre.uniq
            @menubingre=@menubingre.uniq
            #----------------파싱 그대로 가져옴----------------------
                if content=="Humanities"
                    info=""
                    #--문자열 가공
                    if @breakfastprice!=nil
                        info="Breakfast"+"\n"+
                            @breakfasttime+"/"+@breakfastprice+"\n"+
                            @breakfast.shift.titleize+"\n"
                            if @breakfast!=[]
                               info=info+@breakfast.join(",")+"\n"
                            end
                            if @breakfastingre!=[]
                                info=info+@breakfastingre.join(",")+"\n"
                            end
                           info=info+@breakfastkcal+"\n"
                    end
                    if @lunch1price!=nil
                       info=info+"\n"+"Lunch1"+"\n"+
                        @lunch1time+"/"+@lunch1price+"\n"+
                        @lunch1.shift.titleize+"\n"
                        if @lunch1!=[]
                            info=info+@lunch1.join(",")+"\n"
                        end
                        if @lunch1ingre!=[]
                            @lunch1ingre.join(",")+"\n"
                        end
                        info=info+@lunch1kcal+"\n"
                    end
                    if @lunch2price!=nil
                        info=info+"\n"+"Lunch2"+"\n"+
                        @lunch2time+"/"+@lunch2price+"\n"+
                        @lunch2.shift.titleize+"\n"
                        if @lunch2!=[]
                            info=info+@lunch2.join(",")+"\n"
                        end
                        if @lunch2ingre!=[]
                            info=info+@lunch2ingre.join(",")+"\n"
                        end
                        info=info+@lunch2kcal+"\n"
                    end
                    if @lunchnoodleprice!=nil
                        info=info+"\n"+"Lunchnoodles"+"\n"+
                        @lunchnoodletime+"/"+@lunchnoodleprice+"\n"+
                        @lunchnoodle.shift.titleize+"\n"
                        if @lunchnoodle!=[]
                            info=info+@lunchnoodle.join(",")+"\n"
                        end
                        if @lunchnoodleingre!=[]
                            info=info+@lunchnoodleingre.join(",")+"\n"
                        end
                        info=info+@lunchnoodlekcal+"\n"
                    end
                    if @dinnerprice!=nil
                        info=info+"\n"+"Dinner"+"\n"+
                        @dinnertime+"/"+@dinnerprice+"\n"+
                        @dinner.shift.titleize+"\n"
                        if @dinner!=[]
                            info=info+@dinner.join(",")+"\n"
                        end
                        if @dinneringre!=[]
                            info=info+@dinneringre.join(",")+"\n"
                        end
                        info=info+@dinnerkcal+"\n"
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
                elsif content=="Faculty"
                    info=""
                    if @flunchprice!=nil
                        info="Lunch"+"\n"+
                           @flunchtime+"/"+@flunchprice+"\n"+
                           @flunch.shift.titleize+"\n"
                           if @flunch!=[]
                             info=info+@flunch.join(",")+"\n"
                           end
                           if @flunchingre!=[]
                            info=info+@flunchingre.join(",")+"\n"
                           end
                           info=info+@flunchkcal+"\n"
                    end
                    if @fdinnerprice!=nil
                        info=info+"\n"+"Dinner"+"\n"+
                           @fdinnertime+"/"+@fdinnerprice+"\n"+
                           @fdinner.shift.titleize+"\n"
                           if @fdinner!=[]
                             info=info+@fdinner.join(",")+"\n"
                           end
                           if @fdinneringre!=[]
                               info=info+@fdinneringre.join(",")+"\n"
                           end
                           info=info+@fdinnerkcal
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
                else
                    info=""
                    if @menuaprice!=nil
                        info="MenuA"+"\n"+
                           @menuatime+"/"+@menuaprice+"\n"+
                           @menua.shift.titleize+"\n"
                           if @menua!=[]
                             info=info+@menua.join(",")+"\n"
                           end
                           if @menuaingre!=[]
                           info=info+@menuaingre.join(",")+"\n"
                            end
                           info=info+@menuakcal+"\n"
                    end
                    if @menubprice!=nil
                        info=info+"\n"+"MenuB"+"\n"+
                           @menubtime+"/"+@menubprice+"\n"+
                           @menub.shift.titleize+"\n"
                           if @menub!=[]
                            info=info+@menub.join(",")+"\n"
                           end
                           if @menubingre!=[]
                             @menubingre.join(",")+"\n"
                            end
                           info=info+@menubkcal
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
