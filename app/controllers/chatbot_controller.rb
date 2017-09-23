require "Parser"
require "Stringfy"
require "Getlist"

class ChatbotController < ApplicationController
  include Parser
  include Stringfy
  include Getlist
  
    def keyboard
      render json:
      {
        type: "buttons",
        buttons: ["Today Menu", "Choose a Language"]
      }
    end
    
    def message
      user = params[:user_key]
      content = params[:content]
      language = languageHash
      languageArray = language.map{|k, v| v[:showName]}

      
      user = User.find_by(key: user)
      if user == nil
        user = User.new(key: user, count: 0, step: 0)
      end

      user.count = user.count + 1
      user.save

      if content == "Choose a Language"
          
        render json:
        {
          message:{
            text: "Which language do you speak?"  
          },
          
          keyboard: {
            type: "buttons",
            buttons: languageArray
          }
        }
      elsif languageArray.include? content
        language.each do |k, v|
          if v[:showName] == content
            user.language = k
            break
          end
        end
        user.save
        
        render json:
        {
          message: {
            text: "Complete!" + "\n" +
            "You can change the language anytime!"
          },
          keyboard: {
            type: "buttons",
            buttons: ["Today Menu", "Choose a Language"]
          }
        }

      elsif content == "Today Menu"
        if user.language == nil
          user.language = "한국어"
        end
          render json:
          {
            message: {
              text: "Please choose a cafeteria"
            },
            keyboard: {
              type: "buttons",
              buttons: ["Humanities", "Faculty", "Sky Lounge"]
            }
          }

      elsif content == "Humanities" || content == "Faculty" || content == "Sky Lounge"
        imageButtons = []
        @id = user.language.to_i
        time = Time.new.in_time_zone("Seoul")
        dd = time.day
        mm = time.month

        if dd < 10 
          dd = "0" + dd.to_s
        end
          
        if mm < 10 
          mm = "0" + mm.to_s
        end
        
        @day = time.year.to_s + mm.to_s + dd.to_s
        @w = time.wday
        
        check = Lunch1.find_by(date: @day)
        checkf = Flunch.find_by(date: @day)
        checks = Menua.find_by(date: @day)

        begin
          if @w == 0
            rest = Rest.all
            len = rest.length
            begin
              seed_id = rand(0..len-1)
              @ran_rest = rest[seed_id]
            rescue
              @ran_rest = nil
            end
          elsif (@w != 6 && (check == nil || checkf == nil || checks == nil)) || (@w == 6 && check == nil)
            parsing_func(@day)
          end
        rescue Exception => e
          puts e.message
        end
        
        if @w == 0
          render json:
          {
            message: {
              text: "The Cafeteria is closed on sunday." + "\n" +
                "Try eating outside!" + "\n" +
                "How about" + @ran_rest.name + "?",
              photo: {
                "url": "http#{@ran_rest.picture.split("http")[1]}",
                "width": 330,
                "height": 300
              },
              message_button: {
                label: "More Info",
                url: "http://www.hfspn.co/rests/#{@ran_rest.id}"
              }
            },
            keyboard:{
              type: "buttons",
              buttons: ["Today Menu", "Choose a Language"]
            }
          }
        else
          menulist = []
          info = ""

          if content == "Humanities"
            menulist = [Breakfast, Lunch1, Lunch2, Lunchnoodle, Dinner].map{|data| data.make_list(@day, @id)}
            imageButtons = menulist.select{|item| !item[:main].nil?&&item[:main].u_picture&&!item[:main].u_picture.empty?}.map{|item| "Image: #{item[:name].titleize}"}
          elsif content == "Faculty"
            menulist = [Flunch, Fdinner].map{|data| data.make_list(@day, @id)}
              
          else
            menulist = [Menua, Menub].map{|data| data.make_list(@day, @id)}
              
          end

          menulist.each do |meal|
            if meal[:price] != nil || meal[:kcal] != nil
              
              info = info + "<<" + meal[:name].titleize + ">>" + "\n" +
                meal[:time] + "/" + meal[:price] + "\n" + "\n" + 
                meal[:menu].shift.titleize

              if meal[:menu] != []
                info = info + "\n" + meal[:menu].join("\n")
              end
              
              if meal[:ingre] != []
                info = info + "\n" + "\n" + meal[:ingre].join(",")
              else
                info = info + "\n"
              end
              
              if meal[:kcal] != nil
               info = info + "\n" + meal[:kcal]
              end
              if menulist[-1] != meal
                info = info + "\n\n" + "--------"
              end
            end
          end
                
          render json:
          {
            message:{
              text: info,
              message_button: {
                label: "Tomorrow Menus",
                url: "http://www.hfspn.co"
              }
            },
            keyboard:{
              type: "buttons",
              buttons: ["Today Menu", "Choose a Language"] + imageButtons
            }
          }
        end
      elsif content.include? "Image: "
        content = content.gsub("Image: ", "")
        humanities = {
          "Breakfast": Breakfast,
          "Lunch 1": Lunch1,
          "Lunch 2": Lunch2,
          "Lunch Noodles": Lunchnoodle,
          "Dinner": Dinner
        }
        
        @id = user.language.to_i
        time = Time.new.in_time_zone("Seoul")
        dd = time.day
        mm = time.month

        if dd < 10 
          dd = "0" + dd.to_s
        end
          
        if mm < 10 
          mm = "0" + mm.to_s
        end
        
        @day = time.year.to_s + mm.to_s + dd.to_s
        model = humanities.delete(content.to_sym)
        buttons = humanities.values.map{|item| item.make_list(@day, @id)}.select{|item| !item[:main].nil?&&item[:main].u_picture&&!item[:main].u_picture.empty?}.map{|item| "Image: #{item[:name].titleize}"}
        list = model.make_list(@day, @id)
        
        unless list[:main].u_picture.empty?
          render json:
            {
              message: {
                "text": list[:menu][0].titleize,
                "photo": {
                  "url": list[:main].u_picture,
                  "width": 640,
                  "height": 480
                }
              },
              keyboard:{
                type: "buttons",
                buttons: ["Back"] + buttons
              }
            }
        else
          render json:
          {
            message: {
              "text": "Sorry we don't have the image"
            },
            keyboard:{
              type: "buttons",
              buttons: ["Back"] + buttons
            }
          }
        end
        
      elsif content == "Back"
        render json:
        {
          message:{
            text: "Back"
          },
          keyboard:{
            type: "buttons",
            buttons: ["Today Menu", "Choose a Language"]
          }
        }
      
      else
        render json:
        {
          message:{
            text: "Wrong access"
          },
          keyboard:{
            type: "buttons",
            buttons: ["Today Menu", "Choose a Language"]
          }
        }
      end
    end
    
    def delfriend
      begin
        user = params[:user_key]
        user = User.find_by(key: user)
        user.destroy
      rescue
      end
      render json: {}
    end
    
    def regfriend
      user = params[:user_key]
      User.new(key: user, step: 0, count: 0).save
      render json: {}
    end
    
    def chat_room
      user = params[:user_key]
      user = User.find_by(key: user)
      user.chat_room = 0
      user.save
      render json: {}
    end
end